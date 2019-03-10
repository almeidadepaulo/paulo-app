(function() {
    'use strict';

    angular.module('seeawayApp').controller('SiclidXcosifFormCtrl', SiclidXcosifFormCtrl);

    SiclidXcosifFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'exampleService', 'getData'];

    function SiclidXcosifFormCtrl($state, $stateParams, $mdDialog, exampleService, getData) {

        var vm = this;
        vm.init = init;
        vm.example = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id !== null) {
                vm.action = 'update';
                vm.example = vm.getData.example;
                console.info(vm.example);
            } else {
                vm.action = 'create';
            }
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                exampleService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('siclid-x-cosif');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('siclid-x-cosif');
        }

        function save() {

            if ($stateParams.id) {
                //update
                //exampleService.update($stateParams.id, vm.example)
                //fake
                exampleService.update(0, vm.example)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('siclid-x-cosif');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                exampleService.create(vm.example)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('siclid-x-cosif');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();