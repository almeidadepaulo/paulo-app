(function() {
    'use strict';

    angular.module('seeawayApp').controller('ProdutoDialogCtrl', ProdutoDialogCtrl);

    ProdutoDialogCtrl.$inject = ['config', 'produtoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ProdutoDialogCtrl(config, produtoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.produto = {
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
            vm.produto.data = [];
            getData();
        }

        function getData(params) {
            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.produto.page;
            vm.filter.limit = vm.produto.limit;

            if (params.reset) {
                vm.produto.data = [];
            }

            vm.produto.promise = produtoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.produto.total = response.recordCount;
                    vm.produto.data = vm.produto.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function itemClick(item) {
            item = {
                id: item.CB255_CD_PROD,
                name: item.CB255_DS_PROD
            };
            $mdDialog.hide(item);
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();