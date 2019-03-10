(function() {
    'use strict';

    angular.module('seeawayApp').controller('CarteiraDialogCtrl', CarteiraDialogCtrl);

    CarteiraDialogCtrl.$inject = ['config', 'carteiraService', '$rootScope', '$scope', '$state', '$mdDialog', 'locals'];

    function CarteiraDialogCtrl(config, carteiraService, $rootScope, $scope, $state, $mdDialog, locals) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.carteira = {
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

        function init(event) {
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.carteira.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.carteira.page;
            vm.filter.limit = vm.carteira.limit;

            if (locals.contaState) {
                vm.filter.conta = true;
            }

            if (params.reset) {
                vm.carteira.data = [];
            }

            vm.carteira.promise = carteiraService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.carteira.total = response.recordCount;
                    vm.carteira.data = vm.carteira.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            item = {
                id: item.CB256_CD_CART,
                name: item.CB256_DS_CART
            };
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();