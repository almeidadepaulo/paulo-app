(function() {
    'use strict';

    angular.module('seeawayApp').controller('PerfilFormCtrl', PerfilFormCtrl);

    PerfilFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'perfilService', 'getData', 'PERFIL'];

    function PerfilFormCtrl($state, $stateParams, $mdDialog, perfilService, getData, PERFIL) {

        var vm = this;
        vm.init = init;
        vm.perfil = {};
        vm.status = PERFIL.STATUS;
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        vm.dgCosifControl = {};
        vm.dgCosifInit = dgCosifInit;
        //vm.dgCosifLabel = dgCosifLabel;
        //vm.itemClick = itemClick;
        vm.dgCosifConfig = {
            //url: config.REST_URL + '/',
            scrollY: '20vh',
            method: 'GET',
            fields: [{
                title: 'Código',
                field: 'codigo',
                type: 'int'
            }, {
                title: 'Descrição',
                field: 'descricao',
                type: 'varchar'
            }, {
                title: 'Tipo Conta',
                field: 'tipoco',
                type: 'varchar'
            }, {
                title: 'Classificação',
                field: 'classco',
                type: 'varchar'
            }, {
                title: 'Natureza',
                field: 'naturez',
                type: 'varchar'
            }]
        };

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.perfil = {
                    statusSelected: vm.getData.PER_ATIVO,
                    nome: vm.getData.PER_NOME
                };
            } else {
                vm.action = 'create';
                vm.perfil.statusSelected = 1;
                perfilService.jsTreeCedente(0, 1)
                    .then(function success(response) {
                        console.info(response);
                        if (!angular.isDefined($('#jstreeCedente').jstree(true).settings)) {
                            $('#jstreeCedente').jstree(response.jstree);
                        } else {
                            console.info('refresh', response.jstree);
                            $('#jstreeCedente').jstree(true).settings.core.data = response.jstree.core.data;
                            $('#jstreeCedente').jstree(true).refresh();
                        }
                    }, function error(response) {
                        console.error(response);
                    });
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
                perfilService.removeById($stateParams.id)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('perfil-usuario');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('perfil-usuario');
        }

        function save() {

            if ($stateParams.id) {
                //update
                perfilService.update($stateParams.id, vm.perfil)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('perfil-usuario');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                perfilService.create(vm.perfil)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('perfil-usuario');
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function dgCosifInit(event) {
            //vm.getData();

            vm.dgCosifControl.clearData();
            const TIPO = ['Patrimonial', 'Resultado'];

            const CN = [{
                classco: 'Despesa',
                naturez: 'Devedora'
            }, {
                classco: 'Receita',
                naturez: 'Credora'
            }];

            var data = [];
            for (var i = 0; i <= 9; i++) {

                var r = Math.floor((Math.random() * 2));

                data.push({
                    'codigo': i + 161200013000,
                    'descricao': 'Nome ' + Math.floor((Math.random() * 100000) + 1),
                    'tipoco': TIPO[Math.floor((Math.random() * 2))],
                    'classco': CN[r].classco,
                    'naturez': CN[r].naturez
                });
            }

            vm.dgCosifControl.addDataRows(data);
        }
    }
})();