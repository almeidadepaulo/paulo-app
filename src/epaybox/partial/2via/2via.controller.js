(function() {
    'use strict';

    angular.module('seeawayApp').controller('SegundaViaCtrl', SegundaViaCtrl);

    SegundaViaCtrl.$inject = ['config', 'segundaViaService', '$rootScope', '$scope', '$state', '$mdDialog', 'pxStringUtil'];

    function SegundaViaCtrl(config, segundaViaService, $rootScope, $scope, $state, $mdDialog, pxStringUtil) {

        var vm = this;

        vm.filter = {};
        vm.filter.nome = $rootScope.globals.currentUser.nome;
        vm.filter.cpf = $rootScope.globals.currentUser.cpf;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;

        vm.dgExemploControl = {};
        vm.dgExemploInit = dgExemploInit;
        vm.dgExemploLabel = dgExemploLabel;
        vm.itemClick = itemClick;
        vm.dgExemploConfig = {
            url: config.REST_URL + '/epaybox/2via',
            method: 'GET',
            fields: [{
                pk: true,
                visible: false,
                title: 'id',
                field: 'CB210_CD_COMPSC',
                type: 'int'
            }, {
                pk: true,
                visible: false,
                title: 'id',
                field: 'CB210_NR_AGENC',
                type: 'int'
            }, {
                pk: true,
                visible: false,
                title: 'id',
                field: 'CB210_NR_CONTA',
                type: 'int'
            }, {
                pk: true,
                visible: false,
                title: 'id',
                field: 'CB210_NR_NOSNUM',
                type: 'string'
            }, {
                pk: true,
                visible: false,
                title: 'id',
                field: 'CB210_NR_PROTOC',
                type: 'string'
            }, {
                link: true,
                linkId: 'linkAnexo',
                class: 'fa fa-file-pdf-o',
                icon: '',
                title: 'Boleto',
                field: 'CB210_NR_PROTOC',
                type: 'numeric',
                label: 'EM002_ID_IMG',
                align: 'center'
            }, {
                title: 'Sacado',
                field: 'CB201_NM_NMSAC',
                type: 'string'
            }, {
                title: 'Contrato',
                field: 'CB210_NR_CONTRA',
                type: 'string'
            }, {
                pk: true,
                title: 'CPF',
                field: 'CB210_NR_CPFCNPJ',
                type: 'string',
                stringMask: 'cpf'
            }, {
                title: 'Valor',
                field: 'CB210_VL_VALOR',
                type: 'decimal',
                numeral: '0,0.00',
                align: 'right'
            }, {
                title: 'Vencimento',
                field: 'CB210_DT_VCTO',
                type: 'int',
                moment: 'DD/MM/YYYY',
                align: 'center'
            }, {
                title: 'Status',
                field: 'CB210_ID_SITPAG_LABEL',
                type: 'bit',
                label: 'status',
                align: 'center'
            }]
        };

        function dgExemploInit(event) {
            vm.getData();
        }

        function dgExemploLabel(event) {

            if (event.item.label === 'status') {
                if (event.data.CB210_ID_SITPAG_LABEL === 'Em aberto') {
                    event.data.CB210_ID_SITPAG_LABEL = '<span class="label label-warning">EM ABERTO</span>';
                } else if (event.data.CB210_ID_SITPAG_LABEL === 'Pago') {
                    event.data.CB210_ID_SITPAG_LABEL = '<span class="label label-success">PAGO</span>';
                }
            }

            return event;
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'linkAnexo') {
                segundaViaService.getBlobByProtocolo({
                        protocolo: event.itemClick.CB210_NR_PROTOC
                    })
                    .then(function success(response) {
                        //console.info('getBlobByProtocolo', response);
                        var blob = pxStringUtil.toBinary(response.base64, 'application/pdf;base64');
                        var blobUrl = URL.createObjectURL(blob);


                        $scope.pathPdf = 'pdf-viewer/web/viewer.cfm?file=' + blobUrl;

                        PdfCtrl.$inject = ['$scope', '$mdDialog'];

                        // Controller - PDF
                        function PdfCtrl($scope, $mdDialog) {
                            $scope.pdfCancel = function() {
                                $mdDialog.cancel();
                            };
                        }

                        $mdDialog.show({
                            scope: $scope,
                            preserveScope: true,
                            controller: PdfCtrl,
                            template: '<md-dialog ng-cloak aria-label="Anexo">' +
                                '<md-toolbar>' +
                                '<div class="md-toolbar-tools">' +
                                '<h2>Boleto</h2>' +
                                '<span flex></span>' +
                                '<md-button class="md-icon-button" ng-click="pdfCancel()">' +
                                '<i class="fa fa-close"></i>' +
                                '</md-button>' +
                                '</div>' +
                                '</md-toolbar>' +
                                '<iframe id="" src="{{pathPdf}}" style="width: 800px; height: 600px"></iframe>' +
                                '</md-dialog>',
                            parent: angular.element(document.body),
                            targetEvent: event,
                            clickOutsideToClose: false
                        });

                    }, function error(error) {
                        console.error('getBlobByProtocolo', error);
                    });
            }
        }

        /*$scope.$on('', function() {
            
        });*/

        function getData() {
            console.info('$rootScope.current', $rootScope.current);
            vm.dgExemploControl.getData();
        }

        function create() {
            $state.go('example.form');
        }

        function update(id) {
            $state.go('example.form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                segundaViaService.remove(vm.dgExemploControl.selectedItems)
                    .then(function success(response) {
                        if (response.success) {
                            vm.dgExemploControl.removeRow('.selected');
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }
    }
})();