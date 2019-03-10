(function() {
    'use strict';

    angular.module('seeawayApp').controller('PerfilFormCtrl', PerfilFormCtrl);

    PerfilFormCtrl.$inject = ['config', '$state', '$stateParams', '$mdDialog', 'perfilService', 'getData',
        'PERFIL', '$rootScope'
    ];

    function PerfilFormCtrl(config, $state, $stateParams, $mdDialog, perfilService, getData,
        PERFIL, $rootScope) {

        var vm = this;
        vm.init = init;
        vm.perfil = {};
        vm.status = PERFIL.STATUS;
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.jstreeCedenteConfig = jstreeCedenteConfig;
        vm.jstreeMenuConfig = jstreeMenuConfig;
        vm.acesso = acesso;

        function init() {

            vm.loading = vm.loading || {};
            vm.loading.acesso = true;

            if ($stateParams.id) {
                vm.action = 'update';

                vm.perfil = {
                    statusSelected: vm.getData.PER_ATIVO,
                    nome: vm.getData.PER_NOME,
                    per_master: vm.getData.PER_MASTER,
                    per_tipo: vm.getData.PER_TIPO
                };

                perfilService.jsTreeCedente(vm.getData.PER_ID, vm.getData.GRUPO_ID)
                    .then(function success(response) {
                        //console.info('jsTreeCedente',response);
                        if (!angular.isDefined($('#jstreeCedente').jstree(true).settings)) {
                            $('#jstreeCedente').jstree(response.jstree);
                        } else {
                            //console.info('refresh', response.jstree);
                            $('#jstreeCedente').jstree(true).settings.core.data = response.jstree.core.data;
                            $('#jstreeCedente').jstree(true).refresh();
                        }
                    }, function error(response) {
                        console.error(response);
                    });

                var params = {};
                params.perfilId = vm.getData.PER_ID;

                perfilService.jsTreeMenu(params)
                    .then(function success(response) {
                        console.info('jsTreeMenu', response);
                        if (!angular.isDefined($('#jstreeMenu').jstree(true).settings)) {
                            $('#jstreeMenu').jstree(response.jstree);
                        } else {
                            //console.info('refresh', response.jstree);
                            $('#jstreeMenu').jstree(true).settings.core.data = response.jstree.core.data;
                            $('#jstreeMenu').jstree(true).refresh();
                        }
                        vm.loading.acesso = false;
                    }, function error(response) {
                        console.error(response);
                        vm.loading.acesso = false;
                    });
            } else {
                vm.action = 'create';
                vm.perfil.statusSelected = 1;
                vm.perfil.per_master = 0;

                if ($rootScope.globals.currentUser.perfilTipo === 1) { // Perfil admin
                    vm.perfil.per_tipo = 2;
                } else if ($rootScope.globals.currentUser.perfilTipo === 2 || $rootScope.globals.currentUser.perfilTipo === 3) { // Perfil backoffice ou cedente
                    vm.perfil.per_tipo = 3;
                }

                perfilService.jsTreeCedente(0, 1)
                    .then(function success(response) {
                        //console.info(response);
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

                perfilService.jsTreeMenu()
                    .then(function success(response) {
                        console.info(response);
                        if (!angular.isDefined($('#jstreeMenu').jstree(true).settings)) {
                            $('#jstreeMenu').jstree(response.jstree);
                        } else {
                            console.info('refresh', response.jstree);
                            $('#jstreeMenu').jstree(true).settings.core.data = response.jstree.core.data;
                            $('#jstreeMenu').jstree(true).refresh();
                        }
                        vm.loading.acesso = false;
                    }, function error(response) {
                        console.error(response);
                        vm.loading.acesso = false;
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
                            $state.go('perfil-usuario', { tabIndex: 1 });
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
            $state.go('perfil-usuario', { tabIndex: 1 });
        }

        function save() {

            vm.perfil.jstreeDataCedente = vm.jstreeDataCedente;
            vm.perfil.jstreeDataMenu = vm.jstreeDataMenu;

            if ($stateParams.id) {
                //update
                perfilService.update($stateParams.id, vm.perfil)
                    .then(function success(response) {
                        if (response.success) {
                            console.info('success', response);
                            $state.go('perfil-usuario', { tabIndex: 1 });
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
                            $state.go('perfil-usuario', { tabIndex: 1 });
                        } else {
                            console.warn('warn', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function jstreeCedenteConfig() {
            $('#jstreeCedente').on('changed.jstree', function(e, data) {
                //console.info(data);
                vm.jstreeDataCedente = data.selected;
            });
        }

        function jstreeMenuConfig() {
            $('#jstreeMenu').on('changed.jstree', function(e, data) {
                //console.info(data);
                vm.jstreeDataMenu = data.selected;
            });
        }

        function acesso(item) {
            var locals = {};

            $mdDialog.show({
                locals: locals,
                preserveScope: true,
                controller: 'PerfilAcessoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'main/partial/perfil-usuario/perfil-acesso-dialog.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: false
            }).then(function(data) {
                //console.info(data);
            });
        }
    }
})();