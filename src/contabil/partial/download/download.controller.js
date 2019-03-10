(function() {
    'use strict';

    angular.module('seeawayApp').controller('DownloadCtrl', DownloadCtrl);

    DownloadCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog', '$mdToast'];

    function DownloadCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog, $mdToast) {

        var vm = this;

        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;

        vm.dgExemploControl = {};
        vm.dgExemploInit = dgExemploInit;
        vm.dgExemploLabel = dgExemploLabel;
        vm.itemClick = itemClick;
        vm.dgExemploConfig = {
            //url: config.REST_URL + '/example',
            method: 'GET',
            fields: [{
                pk: true,
                title: 'EM805_NR_INST',
                field: 'EM805_NR_INST',
                type: 'numeric',
                visible: false
            }, {
                pk: true,
                title: 'EM805_CD_EMIEMP',
                field: 'EM805_CD_EMIEMP',
                type: 'numeric',
                visible: false
            }, {
                pk: true,
                title: 'EM805_NR_GERAC',
                field: 'EM805_NR_GERAC',
                type: 'numeric',
                visible: false
            }, {
                link: true,
                linkId: 'download',
                title: '',
                class: 'fa fa-download',
                icon: '',
                value: '',
                align: 'center'
            }, {
                title: 'Nome',
                field: 'EM805_NM_ARQ',
                type: 'varchar'
            }, {
                title: 'Data',
                field: 'EM805_DT_PROC',
                type: 'numeric',
                moment: 'dddd - DD/MM/YYYY'
            }, {
                title: 'Hr. Processamento',
                field: 'EM805_HR_PROC_LABEL',
                type: 'varchar'
            }, {
                title: 'Status',
                field: 'EM805_ID_STATUS_LABEL',
                type: 'varchar',
            }, {
                title: 'Usuário',
                field: 'usu_nome',
                type: 'varchar',
            }]
        };

        function dgExemploInit(event) {
            vm.getData();
        }

        function dgExemploLabel(event) {

            return event;
        }

        function itemClick(event) {
            if (event.itemClick.linkId === 'download') {
                console.info('itemClick', event);
                $mdToast.show(
                    $mdToast.simple()
                    .textContent('Seu download irá iniciar em instantes')
                    .position('bottom right')
                    .hideDelay(4000)
                );
            }
        }

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function getData() {
            // fake
            vm.dgExemploControl.clearData();
            var data = [{
                EM805_NR_INST: 1,
                EM805_CD_EMIEMP: 1,
                EM805_NR_GERAC: 1,
                EM805_NM_ARQ: 'Arquivo A',
                EM805_DT_PROC: new Date(),
                EM805_HR_PROC_LABEL: moment().format('HH:mm:ss'),
                EM805_ID_STATUS_LABEL: 'DEMONSTRAÇÃO - DOWNLOAD',
                'usu_nome': $rootScope.globals.currentUser.nome
            }, {
                EM805_NR_INST: 1,
                EM805_CD_EMIEMP: 1,
                EM805_NR_GERAC: 1,
                EM805_NM_ARQ: 'Arquivo B',
                EM805_DT_PROC: new Date(),
                EM805_HR_PROC_LABEL: moment().format('HH:mm:ss'),
                EM805_ID_STATUS_LABEL: 'DEMONSTRAÇÃO - DOWNLOAD',
                'usu_nome': $rootScope.globals.currentUser.nome
            }, {
                EM805_NR_INST: 1,
                EM805_CD_EMIEMP: 1,
                EM805_NR_GERAC: 1,
                EM805_NM_ARQ: 'Arquivo C',
                EM805_DT_PROC: new Date(),
                EM805_HR_PROC_LABEL: moment().format('HH:mm:ss'),
                EM805_ID_STATUS_LABEL: 'DEMONSTRAÇÃO - DOWNLOAD',
                'usu_nome': $rootScope.globals.currentUser.nome
            }];

            for (var i = 0; i <= data.length - 1; i++) {
                vm.dgExemploControl.addDataRow(data[i]);
            }

            //$scope.dgExemploControl.getData();
        }

        function create() {
            $state.go('conta-siclid-form');
        }

        function update(id) {
            $state.go('conta-siclid-form', { id: id });
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                exampleService.remove(vm.dgExemploControl.selectedItems)
                    .then(function success(response) {
                        console.info(response);
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