(function() {
    'use strict';

    angular.module('seeawayApp').controller('AgenciaDialogCtrl', AgenciaDialogCtrl);

    AgenciaDialogCtrl.$inject = ['config', 'agenciaService', '$rootScope', '$scope', '$state', '$mdDialog', 'banco'];

    function AgenciaDialogCtrl(config, agenciaService, $rootScope, $scope, $state, $mdDialog, banco) {

        var vm = this;
        vm.init = init;
        vm.switch = 'list';
        vm.filter = {};
        vm.getData = getData;
        vm.agencia = {
            limit: 5,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.itemClick = itemClick;
        vm.cancel = cancel;
        vm.agenciaForm = {};
        vm.back = back;
        vm.create = create;
        vm.update = update;
        vm.save = save;
        vm.cepSearch = cepSearch;

        function init(event) {
            if (banco.id) {
                vm.filter.CB251_CD_COMPSC = banco.id;
                vm.agenciaForm.CB251_CD_COMPSC = banco.id;
                vm.agenciaForm.CB250_NM_BANCO = banco.name;
            }

            vm.agenciaForm.CB251_NR_CEP = '';
            vm.agenciaForm.CB251_NM_END = '';
            vm.agenciaForm.CB251_NR_END = '';
            vm.agenciaForm.CB251_DS_COMPL = '';
            vm.agenciaForm.CB251_NM_BAIRRO = '';
            vm.agenciaForm.CB251_SG_ESTADO = '';
            vm.agenciaForm.CB251_NM_CIDADE = '';
            vm.agenciaForm.CB251_DS_COMPL = '';


            vm.formShow = !banco.contaState;

            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.agencia.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.agencia.page;
            vm.filter.limit = vm.agencia.limit;

            if (params.reset) {
                vm.agencia.data = [];
            }

            vm.agencia.promise = agenciaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.agencia.total = response.recordCount;
                    vm.agencia.data = vm.agencia.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            item = {
                id: item.CB251_NR_AGENC,
                name: item.CB251_NR_AGENC + ' - ' + item.CB251_NM_AGENC,
                item: item
            };
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }

        function back() {
            vm.switch = 'list';
        }

        function create() {
            vm.action = 'create';
            vm.switch = 'form';
        }

        function update(id) {
            vm.action = 'update';
            vm.id = id;
            agenciaService.getById(id, vm.agenciaForm)
                .then(function success(response) {
                    console.info('success', response);

                    vm.switch = 'form';

                    response.query[0].CB251_CD_COMPSC = parseInt(response.query[0].CB251_CD_COMPSC);
                    response.query[0].CB251_NR_AGENC = parseInt(response.query[0].CB251_NR_AGENC);
                    response.query[0].CB251_NR_DGAGEN = parseInt(response.query[0].CB251_NR_DGAGEN);

                    vm.agenciaForm = response.query[0];

                }, function error(response) {
                    console.error('error', response);
                });
        }

        function save() {

            if (vm.id) {
                //update
                agenciaService.update(vm.id, vm.agenciaForm)
                    .then(function success(response) {
                        console.info('success', response);
                        if (response.success) {
                            var item = {
                                id: vm.agenciaForm.CB250_CD_COMPSC,
                                name: vm.agenciaForm.CB250_NM_BANCO
                            };
                            $mdDialog.hide(item);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                agenciaService.create(vm.agenciaForm)
                    .then(function success(response) {
                        if (response.success) {
                            var item = {
                                id: vm.agenciaForm.CB251_NR_AGENC,
                                name: vm.agenciaForm.CB251_NR_AGENC + '-' + vm.agenciaForm.CB251_NR_DGAGEN
                            };
                            $mdDialog.hide(item);
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function cepSearch(event) {
            //console.info('cepSearch', event);
            vm.agenciaForm.CB251_NM_END = event.data.logradouro;
            vm.agenciaForm.CB251_NM_BAIRRO = event.data.bairro;
            vm.agenciaForm.CB251_NM_CIDADE = event.data.localidade;
            vm.agenciaForm.CB251_SG_ESTADO = event.data.uf;
        }

    }
})();