(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailPesquisaCtrl', EmailPesquisaCtrl);

    EmailPesquisaCtrl.$inject = ['config', 'emailPesquisaService', '$rootScope', '$scope', '$state', '$mdDialog',
        'protocoloService', 'stringUtil'
    ];

    function EmailPesquisaCtrl(config, emailPesquisaService, $rootScope, $scope, $state, $mdDialog,
        protocoloService, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.emailPesquisa = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.filterDialog = filterDialog;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            vm.filter = vm.filter || {};
            vm.filter.EM002_DT_REMESS = '';
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.emailPesquisa.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailPesquisa.page;
            vm.filter.limit = vm.emailPesquisa.limit;

            if (params.reset) {
                vm.emailPesquisa.data = [];
            }

            vm.emailPesquisa.promise = emailPesquisaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailPesquisa.total = response.recordCount;
                    vm.emailPesquisa.data = vm.emailPesquisa.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function filterDialog(model, item) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {

                case 'mensagem':
                    locals.filter = vm.filter;
                    locals.item = item;
                    controller = 'EmailPesquisaDetalheDialogCtrl';
                    templateUrl = 'publish/partial/email-pesquisa/email-pesquisa-detalhe-dialog.html';
                    break;

                case 'anexo':
                    protocoloService.getBlob(item.EM002_ID_IMG)
                        .then(function success(response) {
                            console.info(response);

                            var extensao = item.EM002_NM_ANEXO.split('.')[item.EM002_NM_ANEXO.split('.').length - 1];
                            extensao = extensao.trim();
                            locals.title = item.EM002_NM_ANEXO;

                            var blob = stringUtil.toBinary(response.base64, 'application/pdf;base64');
                            var blobUrl = URL.createObjectURL(blob);

                            if (extensao.toLowerCase() === 'pdf') {
                                locals.pathPdf = 'pdf-viewer/web/viewer.cfm?file=' + blobUrl;
                                controller = 'EmailPesquisaPdfDialogCtrl';
                                templateUrl = 'publish/partial/email-pesquisa/email-pesquisa-pdf-dialog.html';

                                $mdDialog.show({
                                    locals: locals,
                                    preserveScope: true,
                                    controller: controller,
                                    controllerAs: 'vm',
                                    templateUrl: templateUrl,
                                    parent: angular.element(document.body),
                                    //targetEvent: event,
                                    clickOutsideToClose: true
                                }).then(function(data) {
                                    //console.info(data);               
                                });
                            } else {
                                var a = document.createElement('a');
                                document.body.appendChild(a);
                                a.style = 'display: none';
                                a.href = blobUrl;
                                a.download = item.EM002_NM_ANEXO;
                                a.click();
                                window.URL.revokeObjectURL(blobUrl);
                            }

                        }, function error(response) {
                            console.error(response);
                        });
                    break;
            }

            if (model !== 'anexo') {
                $mdDialog.show({
                    locals: locals,
                    preserveScope: true,
                    controller: controller,
                    controllerAs: 'vm',
                    templateUrl: templateUrl,
                    parent: angular.element(document.body),
                    //targetEvent: event,
                    clickOutsideToClose: true
                }).then(function(data) {
                    //console.info(data);               
                });
            }
        }

    }
})();