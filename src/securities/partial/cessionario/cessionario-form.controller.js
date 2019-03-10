(function() {
    'use strict';

    angular.module('seeawayApp').controller('CessionarioFormCtrl', CessionarioFormCtrl);

    CessionarioFormCtrl.$inject = ['$rootScope', '$state', '$stateParams', '$mdDialog', 'cessionarioService', 'getData'];

    function CessionarioFormCtrl($rootScope, $state, $stateParams, $mdDialog, cessionarioService, getData) {

        var vm = this;
        vm.init = init;
        vm.cessionario = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.cepSearch = cepSearch;

        function init() {
            vm.perfilTipo = $rootScope.globals.currentUser.perfilTipo;

            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB058_NR_CPFCNPJ = String(vm.getData.CB058_NR_CPFCNPJ);
                vm.getData.CB058_NR_CEP = String(vm.getData.CB058_NR_CEP).trim();
                vm.getData.CB058_NR_TEL = String(vm.getData.CB058_NR_DDD) + String(vm.getData.CB058_NR_TEL);
                vm.getData.CB058_NR_CEL = String(vm.getData.CB058_NR_DDDC) + String(vm.getData.CB058_NR_CEL);
                vm.cessionario = vm.getData;
            } else {
                vm.action = 'create';
                vm.cessionario.CB058_NM_COMPL = '';
                vm.cessionario.CB058_NM_EMAIL2 = '';
                vm.cessionario.CB058_NR_CEL = '';
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
                cessionarioService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('cessionario');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('cessionario');
        }

        function save() {

            if ($stateParams.id) {
                //update
                cessionarioService.update($stateParams.id, vm.cessionario)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('cessionario');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                cessionarioService.create(vm.cessionario)
                    .then(function success(response) {
                        if (response.success) {
                            if (JSON.parse(localStorage.getItem('cessionario')).form) {

                                vm.filter = {};
                                vm.filter.page = 1;
                                vm.filter.limit = 1;

                                cessionarioService.get(vm.filter)
                                    .then(function success(response) {
                                        response.query[0].form = false;
                                        localStorage.setItem('cessionario', JSON.stringify(response.query[0]));

                                        $rootScope.$broadcast('home-cessionario-update', {
                                            cessionario: response.query[0]
                                        });

                                        $state.go('menu');
                                        //$state.reload();
                                    }, function error(response) {
                                        console.error('error', response);
                                    });
                            } else {
                                $state.go('cessionario');
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
            vm.cessionario.CB058_NM_END = event.data.logradouro;
            vm.cessionario.CB058_NM_BAIRRO = event.data.bairro;
            vm.cessionario.CB058_NM_CIDADE = event.data.localidade;
            vm.cessionario.CB058_NM_ESTADO = event.data.uf;
        }
    }
})();