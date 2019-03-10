(function() {
    'use strict';

    angular.module('seeawayApp').controller('TarifasFormCtrl', TarifasFormCtrl);

    TarifasFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'tarifasService', 'getData'];

    function TarifasFormCtrl($state, $stateParams, $mdDialog, tarifasService, getData) {

        var vm = this;
        vm.init = init;
        vm.tarifas = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.filter = {};
        vm.filterDialog = filterDialog;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB059_CD_TARIFA = parseInt(vm.getData.CB059_CD_TARIFA);
                vm.getData.CB059_CD_TARIFA = parseInt(vm.getData.CB059_CD_TARIFA);
                vm.tarifas = vm.getData;
                vm.filter.banco = {
                    id: vm.getData.CB059_NR_BANCO,
                    name: vm.getData.CB250_NM_BANCO
                };
            } else {
                vm.action = 'create';
                vm.tarifas.CB059_CD_TARIFA = 'Automático';
            }
        }

        function filterDialog(model) {

            var controller = '';
            var templateUrl = '';
            var locals = {};
            locals.contaState = true;

            switch (model) {
                case 'banco':
                    controller = 'BancoDialogCtrl';
                    templateUrl = 'collect/partial/banco/banco-dialog.html';
                    break;
            }

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
                vm.filter[model] = data;

                switch (model) {
                    case 'banco':
                        vm.tarifas.CB059_NR_BANCO = data.id;
                        break;
                }
            });
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                tarifasService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('tarifas');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('tarifas');
        }

        function save() {

            if ($stateParams.id) {
                //update
                tarifasService.update($stateParams.id, vm.tarifas)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('tarifas');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                tarifasService.create(vm.tarifas)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('tarifas');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();