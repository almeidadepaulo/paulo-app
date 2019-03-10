(function() {
    'use strict';

    angular.module('seeawayApp').controller('UsuarioFormCtrl', UsuarioFormCtrl);

    UsuarioFormCtrl.$inject = ['$scope', '$state', '$stateParams', '$mdDialog', 'usuarioService', 'getData', 'USUARIO'];

    function UsuarioFormCtrl($scope, $state, $stateParams, $mdDialog, usuarioService, getData, USUARIO) {

        var vm = this;
        vm.init = init;
        vm.usuario = {};
        vm.status = USUARIO.STATUS;
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.passwordRedefine = passwordRedefine;
        vm.perfilDialog = perfilDialog;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.passwordDisabled = true;
                vm.usuario = {
                    statusSelected: vm.getData.USU_ATIVO,
                    perfil: {
                        id: vm.getData.PER_ID,
                        nome: vm.getData.PER_NOME
                    },
                    nome: vm.getData.USU_NOME,
                    login: vm.getData.USU_LOGIN,
                    email: vm.getData.USU_EMAIL,
                    cpf: String(vm.getData.USU_CPF),
                    senha: '***************************',
                    senha2: '***************************',
                    senhaModificar: vm.getData.USU_MUDARSENHA === 1
                };
            } else {
                vm.passwordDisabled = false;
                vm.usuario.statusSelected = 1;
                vm.usuario.senhaModificar = false;
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
                usuarioService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('perfil-usuario', { tabIndex: 1 });
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

            if ($stateParams.id) {
                //update
                usuarioService.update($stateParams.id, vm.usuario)
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
                usuarioService.create(vm.usuario)
                    .then(function success(response) {
                        console.info('success', response);
                        if (response.success) {
                            $state.go('perfil-usuario', { tabIndex: 1 });
                        } else {
                            console.error('error', response);
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function passwordRedefine() {
            vm.usuario.senha = '';
            vm.usuario.senha2 = '';
            vm.passwordDisabled = false;
        }

        function perfilDialog(event) {
            $mdDialog.show({
                scope: $scope,
                preserveScope: true,
                controller: DialogController,
                controllerAs: vm,
                templateUrl: 'contabil/partial/perfil-usuario/perfil-dialog.html',
                parent: angular.element(document.body),
                targetEvent: event,
                clickOutsideToClose: true
            });

            DialogController.$inject = ['config', '$scope', '$mdDialog', '$state'];

            function DialogController(config, $scope, $mdDialog, $state) {

                vm.hide = hide;
                vm.cancel = cancel;

                vm.getData = getData;
                vm.dgPerfilControl = {};
                vm.dgPerfilInit = dgPerfilInit;
                //vm.dgPerfilLabel = dgPerfilLabel;
                vm.itemClick = itemClick;
                vm.dgPerfilConfig = {
                    url: config.REST_URL + '/perfil',
                    scrollY: '40vh',
                    method: 'GET',
                    fields: [{
                        pk: true,
                        visible: false,
                        title: 'ID',
                        field: 'per_id',
                        type: 'int',
                        identity: true
                    }, {
                        link: true,
                        linkId: 'done',
                        title: '',
                        class: 'material-icons',
                        icon: 'done',
                        value: '',
                        align: 'center'
                    }, {
                        title: 'Nome',
                        field: 'per_nome',
                        type: 'string'
                    }, {
                        title: 'Status',
                        field: 'per_ativo_label',
                        type: 'bit'
                    }]
                };

                function hide() {
                    $mdDialog.hide();
                }

                function cancel() {
                    $mdDialog.cancel();
                }

                function dgPerfilInit(event) {
                    vm.getData();
                }

                function itemClick(event) {
                    if (event.itemClick.linkId === 'done') {
                        $scope.vm.usuario.perfil = {
                            id: event.itemClick.per_id,
                            nome: event.itemClick.per_nome
                        };
                        hide();
                    }
                }

                function getData() {
                    vm.filter = vm.filter || {};
                    vm.dgPerfilControl.getData(vm.filter);
                }
            }
        }
    }
})();