(function() {
    'use strict';

    angular.module('seeawayApp').controller('LoginCtrl', LoginCtrl);

    LoginCtrl.$inject = ['$rootScope', '$scope', 'loginService', '$state', '$stateParams', '$mdDialog'];
    /* @ngInject */
    function LoginCtrl($rootScope, $scope, loginService, $state, $stateParams, $mdDialog) {
        var vm = this;
        vm.dataLoading = false;
        vm.selection = 'default';
        vm.formTitle = 'Login';
        vm.loginMessage = '';
        vm.login = login;
        vm.redefineForm = redefineForm;
        vm.redefine = redefine;
        vm.recover = recover;
        vm.showLogin = showLogin;
        vm.showRecover = showRecover;
        vm.register = register;

        function login() {
            if (vm.selection === 'default') {
                vm.dataLoading = true;

                loginService.Login(vm.username, vm.password)
                    .then(function success(response) {
                        //console.info('login', response);                        
                        vm.loginMessage = response.data.message;

                        if (response.data.success) {
                            if (response.data.passwordChange) {
                                vm.dataLoading = false;
                                vm.formTitle = 'Alteração de senha';
                                vm.selection = 'redefine';
                                vm.id = response.data.userId;
                                return;
                            }
                            localStorage.removeItem('cedente');
                            loginService.SetCredentials(vm.username, vm.password, response.data);
                            $state.go('home');
                        } else {
                            vm.dataLoading = false;
                            vm.username = '';
                            vm.password = '';
                            console.warn(response.data.message);
                        }
                    }, function error(response) {
                        //console.error('login', response);
                        vm.dataLoading = false;
                        vm.username = '';
                        vm.password = '';
                        vm.loginMessage = 'Usuário e/ou senha incorreto(s)';
                        document.getElementById('username').focus();
                    });
            }
        }

        function redefineForm() {
            // Validar senha atual
            if (String(vm.password) !== String(vm.passwordOld)) {
                $scope.loginForm.passwordOld.$setValidity('confirm', false);
            } else {
                $scope.loginForm.passwordOld.$setValidity('confirm', true);
            }
        }

        function redefine() {
            vm.dataLoading = true;

            var data = {
                username: vm.username,
                passwordOld: vm.passwordOld,
                passwordNew: vm.passwordNew
            };

            loginService.Redefine(data)
                .then(function success(response) {
                    //console.info(response);

                    if (response.data.success) {
                        loginService.SetCredentials(vm.username, vm.passwordNew, response.data);
                        $state.go('home');
                    } else {
                        vm.loginMessage = response.data.message;
                        vm.dataLoading = false;
                    }
                }, function error(response) {
                    console.error(response);
                });
        }

        // função não implementada!
        function recover() {
            vm.dataLoading = true;

            var data = {
                username: vm.usernameRecover,
                email: vm.email
            };

            loginService.Recover(data)
                .then(function success(response) {
                    console.info(response);
                    if (response.data.success) {
                        $mdDialog.show(
                            $mdDialog.alert()
                            .clickOutsideToClose(false)
                            .title('Aviso')
                            .textContent('Foi enviado um e-mail para ' + vm.email + ' com as instruções de recuperação de login')
                            .ok('Fechar')
                        );

                        //vm.showLogin();
                        $state.reload();
                    } else {
                        vm.loginMessage = response.data.message;
                        vm.dataLoading = false;
                    }
                }, function error(response) {
                    console.error(response);
                });
        }

        function showLogin() {
            vm.password = '';
            vm.email = '';
            vm.passwordOld = '';
            vm.password = '';
            vm.passwordNewConfirm = '';
            vm.loginMessage = '';
            vm.formTitle = 'Login';
            vm.selection = 'default';
        }

        function showRecover() {
            vm.password = '';
            vm.loginMessage = '';
            vm.formTitle = 'Recuperar senha';
            vm.selection = 'recover';
        }

        function register() {
            $state.go('register');
        }
    }
})();