(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContaContabilFormCtrl', ContaContabilFormCtrl);

    ContaContabilFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'getData'];

    function ContaContabilFormCtrl($state, $stateParams, $mdDialog, getData) {

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
            } else {
                vm.action = 'create';
            }
        }

        function removeById(event) {

        }

        function cancel() {
            $state.go('conta-contabil');
        }

        function save() {

        }
    }
})();