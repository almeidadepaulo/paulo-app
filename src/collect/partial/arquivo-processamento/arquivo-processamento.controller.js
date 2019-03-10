(function() {
    'use strict';

    angular.module('seeawayApp').controller('ArquivoProcessamentoCtrl', ArquivoProcessamentoCtrl);

    ArquivoProcessamentoCtrl.$inject = ['config', '$rootScope', '$scope', '$state', '$mdDialog', '$mdToast'];

    function ArquivoProcessamentoCtrl(config, $rootScope, $scope, $state, $mdDialog, $mdToast) {

        var vm = this;
        vm.init = init;
        vm.itemClick = itemClick;
        vm.getData = getData;
        vm.arquivoProcessamento = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.arquivoProcessamento.data = [];
            getData();
        }

        function getData(params) {

            vm.arquivoProcessamento.data = [{
                EM805_NR_INST: 1,
                EM805_CD_EMIEMP: 1,
                EM805_NR_GERAC: 1,
                EM805_NM_ARQ: 'Arquivo A',
                EM805_DT_PROC: new Date(),
                EM805_HR_PROC_LABEL: moment().format('HH:mm:ss'),
                EM805_ID_STATUS_LABEL: 'ARQUIVO INVÁLIDO',
                'usu_nome': $rootScope.globals.currentUser.nome
            }, {
                EM805_NR_INST: 1,
                EM805_CD_EMIEMP: 1,
                EM805_NR_GERAC: 1,
                EM805_NM_ARQ: 'Arquivo B',
                EM805_DT_PROC: new Date(),
                EM805_HR_PROC_LABEL: moment().format('HH:mm:ss'),
                EM805_ID_STATUS_LABEL: 'PROCESSADO COM SUCESSO',
                'usu_nome': $rootScope.globals.currentUser.nome
            }, {
                EM805_NR_INST: 1,
                EM805_CD_EMIEMP: 1,
                EM805_NR_GERAC: 1,
                EM805_NM_ARQ: 'Arquivo C',
                EM805_DT_PROC: new Date(),
                EM805_HR_PROC_LABEL: moment().format('HH:mm:ss'),
                EM805_ID_STATUS_LABEL: 'NA FILA DE ESPERA',
                'usu_nome': $rootScope.globals.currentUser.nome
            }];

            /*params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.arquivoProcessamento.page;
            vm.filter.limit = vm.arquivoProcessamento.limit;

            if (params.reset) {
                vm.arquivoProcessamento.data = [];
            }

            vm.arquivoProcessamento.promise = arquivoProcessamentoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.arquivoProcessamento.total = response.recordCount;
                    vm.arquivoProcessamento.data = vm.arquivoProcessamento.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
            */
        }

        function itemClick(event) {
            $mdToast.show(
                $mdToast.simple()
                .textContent('Seu arquivoProcessamento irá iniciar em instantes')
                .position('bottom right')
                .hideDelay(4000)
            );
        }
    }
})();