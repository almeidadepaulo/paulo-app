(function() {
    'use strict';

    angular.module('seeawayApp').controller('RegisterCtrl', RegisterCtrl);

    RegisterCtrl.$inject = ['$state', '$timeout', 'registerService', '$mdDialog'];
    /* @ngInject */
    function RegisterCtrl($state, $timeout, registerService, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.register = {};
        vm.next = next;
        vm.back = back;
        vm.tipoPessoaChange = tipoPessoaChange;
        vm.cepSearch = cepSearch;
        vm.cancel = cancel;
        vm.upload = upload;

        function init() {
            // Steps!
            // http://embed.plnkr.co/M03tYgtfqNH09U4x5pHC/preview

            vm.step = {
                profile: {
                    back: '',
                    next: 'address'
                },
                info: {
                    back: 'profile',
                    next: 'address'
                },
                address: {
                    back: 'profile',
                    next: 'doc'
                },
                doc: {
                    back: 'address',
                    next: 'save'
                }
            };

            if ($state.current.name !== 'register.profile') {
                $timeout(function() {
                    $state.go('register.profile');
                }, 0);
            }

            //defaults
            vm.register.CL001_TP_PESSOA = 'F';
            vm.register.CL001_NM_COMPL = '';
        }

        function next() {
            vm.currentState = 'register.' + vm.step[$state.current.url.replace('/', '')].next;

            if (vm.currentState !== 'register.save') {
                $state.go(vm.currentState);
            } else {
                // create a new formdata
                var fd = new FormData();
                fd.append('rg', vm.file.rg);
                fd.append('body', JSON.stringify(vm.register));

                console.log(fd);

                registerService.create(fd)
                    .then(function success(response) {
                        console.info(response);

                        $mdDialog.show(
                            $mdDialog.alert()
                            .clickOutsideToClose(true)
                            .title('Aviso')
                            .textContent('Informações enviadas com sucesso, entraremos em contato em breve!')
                            .ariaLabel('Aviso')
                            .ok('Fechar')
                        );
                    }, function error(response) {
                        console.error(response);
                    });
            }
        }

        function back() {
            vm.currentState = 'register.' + vm.step[$state.current.url.replace('/', '')].back;
            $state.go(vm.currentState);
        }

        function tipoPessoaChange(tipo) {
            vm.register.CL001_NR_CPFCNPJ = '';
        }

        function cepSearch(event) {
            //console.info('cepSearch', event);
            vm.register.CL001_NM_END = event.data.logradouro;
            vm.register.CL001_NM_BAIRRO = event.data.bairro;
            vm.register.CL001_NM_CIDADE = event.data.localidade;
            vm.register.CL001_SG_ESTADO = event.data.uf;
        }

        function cancel() {
            window.history.back();
        }

        function upload(file) {

        }
    }
})();