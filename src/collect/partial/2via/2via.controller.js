(function() {
    'use strict';

    angular.module('seeawayApp').controller('SegundaviaCtrl', SegundaviaCtrl);

    SegundaviaCtrl.$inject = ['config', 'segundaViaService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SegundaviaCtrl(config, segundaViaService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        // vm.create = create;
        vm.update = update;
        // vm.remove = remove;
        vm.segundaVia = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.showPdf = showPdf;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            vm.filter.CB210_DT_VCTO = null; //new Date();
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.segundaVia.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.segundaVia.page;
            vm.filter.limit = vm.segundaVia.limit;

            if (params.reset) {
                vm.segundaVia.data = [];
            }

            vm.segundaVia.promise = segundaViaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.segundaVia.total = response.recordCount;
                    vm.segundaVia.data = vm.segundaVia.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        //function create() {
        //    $state.go('2via-form');
        //}

        function update(id) {
            $state.go('2via-form', id);
        }

        function showPdf(item) {
            var locals = {
                items: vm.segundaVia.selected
            };
            $mdDialog.show({
                locals: locals,
                preserveScope: true,
                controller: 'SegundaViaPdfDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'collect/partial/2via/2via-pdf-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: false
            }).then(function(data) {
                //console.info(data);
            });
        }
    }
})();