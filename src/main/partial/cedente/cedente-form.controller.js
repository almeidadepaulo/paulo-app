(function() {
    'use strict';

    angular.module('seeawayApp').controller('CedenteFormCtrl', CedenteFormCtrl);

    CedenteFormCtrl.$inject = ['$rootScope', '$state', '$stateParams', '$mdDialog', 'cedenteService', 'getData'];

    function CedenteFormCtrl($rootScope, $state, $stateParams, $mdDialog, cedenteService, getData) {

        var vm = this;
        vm.init = init;
        vm.cedente = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.cepSearch = cepSearch;
        vm.saveCedenteContato = saveCedenteContato;

        function init() {
            vm.perfilTipo = $rootScope.globals.currentUser.perfilTipo;

            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB053_NR_CPFCNPJ = String(vm.getData.CB053_NR_CPFCNPJ);
                vm.getData.CB053_NR_CEP = String(vm.getData.CB053_NR_CEP).trim();
                vm.getData.CB053_NR_TEL = String(vm.getData.CB053_NR_DDD) + String(vm.getData.CB053_NR_TEL);
                vm.getData.CB053_NR_CEL = String(vm.getData.CB053_NR_DDDC) + String(vm.getData.CB053_NR_CEL);
                vm.cedente = vm.getData;
            } else {
                vm.action = 'create';
                vm.cedente.CB053_CD_EMIEMP = 'Automático';
                vm.cedente.CB053_NM_COMPL = '';
                vm.cedente.CB053_NM_EMAIL2 = '';
                vm.cedente.CB053_NR_CEL = '';
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
                cedenteService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        if ($rootScope.globals.currentUser.perfilTipo === 3) {
                            $state.go('menu');
                        } else {
                            $state.go('cedente');
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            if ($rootScope.globals.currentUser.perfilTipo === 3) {
                $state.go('menu');
            } else {
                $state.go('cedente');
            }
        }

        function save() {

            if ($stateParams.id) {
                //update
                cedenteService.update($stateParams.id, vm.cedente)
                    .then(function success(response) {
                        console.info('success', response);
                        if ($rootScope.globals.currentUser.perfilTipo === 3) {
                            $state.go('menu');
                        } else {
                            $state.go('cedente');
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                cedenteService.create(vm.cedente)
                    .then(function success(response) {
                        if (response.success) {
                            if (JSON.parse(localStorage.getItem('cedente')).form) {

                                vm.filter = {};
                                vm.filter.page = 1;
                                vm.filter.limit = 1;

                                cedenteService.get(vm.filter)
                                    .then(function success(response) {
                                        response.query[0].form = false;
                                        localStorage.setItem('cedente', JSON.stringify(response.query[0]));

                                        $rootScope.$broadcast('home-cedente-update', {
                                            cedente: response.query[0]
                                        });

                                        $state.go('menu');
                                        //$state.reload();
                                    }, function error(response) {
                                        console.error('error', response);
                                    });
                            } else {
                                if ($rootScope.globals.currentUser.perfilTipo === 3) {
                                    $state.go('menu');
                                } else {
                                    $state.go('cedente');
                                }
                            }
                        }
                        console.info('success', response);

                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function cepSearch(event) {
            //console.info('cepSearch', event);
            vm.cedente.CB053_NM_END = event.data.logradouro;
            vm.cedente.CB053_NM_BAIRRO = event.data.bairro;
            vm.cedente.CB053_NM_CIDADE = event.data.localidade;
            vm.cedente.CB053_NM_ESTADO = event.data.uf;
        }

        function saveCedenteContato() {
            $mdDialog.show({
                locals: {},
                preserveScope: true,
                controller: 'ContatoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'collect/partial/contato/contato-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                console.info(vm.smsCedenteContato.total, data);
                vm.smsCedenteContato.total = vm.smsCedenteContato.total + data.length;
                vm.smsCedenteContato.data = vm.smsCedenteContato.data.concat(data);
            });
        }
    }
})();