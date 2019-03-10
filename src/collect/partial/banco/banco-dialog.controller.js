(function() {
    'use strict';

    angular.module('seeawayApp').controller('BancoDialogCtrl', BancoDialogCtrl);

    BancoDialogCtrl.$inject = ['config', 'bancoService', '$rootScope', '$scope', '$state', '$mdDialog', 'locals'];

    function BancoDialogCtrl(config, bancoService, $rootScope, $scope, $state, $mdDialog, locals) {

        var vm = this;
        vm.init = init;
        vm.switch = 'list';
        vm.getData = getData;
        vm.banco = {
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
        vm.bancoForm = {};
        vm.back = back;
        vm.create = create;
        vm.update = update;
        vm.save = save;
        vm.cepSearch = cepSearch;

        function init(event) {
            getData({ reset: true });

            vm.formShow = !locals.contaState;
        }

        function pagination(page, limit) {
            vm.banco.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.banco.page;
            vm.filter.limit = vm.banco.limit;

            if (params.reset) {
                vm.banco.data = [];
            }

            vm.banco.promise = bancoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.banco.total = response.recordCount;
                    vm.banco.data = vm.banco.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            item = {
                id: item.CB250_CD_COMPSC,
                name: item.CB250_NM_BANCO
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

            // defaults
            vm.bancoForm.CB250_DS_COMPL = '';
            vm.bancoForm.CB250_NR_NOSNUM = '';
        }

        function update(id) {
            vm.action = 'update';
            vm.id = id;
            bancoService.getById(id, vm.bancoForm)
                .then(function success(response) {
                    console.info('success', response);

                    vm.switch = 'form';

                    response.query[0].CB250_CD_COMPSC = parseInt(response.query[0].CB250_CD_COMPSC);
                    vm.bancoForm = response.query[0];

                }, function error(response) {
                    console.error('error', response);
                });
        }

        function save() {

            if (vm.id) {
                //update
                bancoService.update(vm.id, vm.bancoForm)
                    .then(function success(response) {
                        console.info('success', response);
                        if (response.success) {
                            var item = {
                                id: vm.bancoForm.CB250_CD_COMPSC,
                                name: vm.bancoForm.CB250_NM_BANCO
                            };
                            $mdDialog.hide(item);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                bancoService.create(vm.bancoForm)
                    .then(function success(response) {
                        if (response.success) {
                            var item = {
                                id: vm.bancoForm.CB250_CD_COMPSC,
                                name: vm.bancoForm.CB250_NM_BANCO
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
            vm.bancoForm.CB250_NM_END = event.data.logradouro;
            vm.bancoForm.CB250_NM_BAIRRO = event.data.bairro;
            vm.bancoForm.CB250_NM_CIDADE = event.data.localidade;
            vm.bancoForm.CB250_SG_ESTADO = event.data.uf;
        }
    }
})();