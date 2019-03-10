(function() {
    'use strict';

    angular.module('seeawayApp').controller('MenuCtrl', MenuCtrl);

    MenuCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$stateParams', '$mdDialog'];

    function MenuCtrl(config, exampleService, $rootScope, $scope, $state, $stateParams, $mdDialog) {

        var vm = this;
        vm.menus = {};

        switch ($stateParams.id) {
            case 'sms':
                vm.menus.menuZone1 = {
                    items: [{
                        title: 'Brokers',
                        notes: 'Brokers são responsáveis pelo envio do SMS',
                        state: 'sms-broker'
                    }, {
                        title: 'Pacotes',
                        notes: 'Gerencie pacotes de SMS',
                        state: 'sms-pacote'
                    }, {
                        title: 'Códigos de SMS',
                        notes: 'Gerencie códigos de SMS',
                        state: 'sms-codigo'
                    }, {
                        title: 'Prioridade',
                        notes: 'Defina prioridade de envio de SMS',
                        state: 'sms-prioridade'
                    }, {
                        title: 'Variáveis',
                        notes: 'Variáveis disponíveis para SMS',
                        state: 'sms-variavel'
                    }, {
                        title: 'Mensagens',
                        notes: 'Gerencie mensagens de SMS',
                        state: 'sms-mensagem'
                    }, {
                        title: 'Blacklist',
                        notes: 'Gerencie blacklist para SMS',
                        state: 'sms-blacklist'
                    }, {
                        title: 'Parâmetros',
                        notes: 'Defina parâmetros para SMS',
                        state: 'sms-parametro'
                    }]
                };

                vm.menus.menuZone2 = {
                    items: [{
                        title: 'Resumo de mensagens',
                        notes: 'Veja quantidade mensagens por data de movimento',
                        state: 'sms-resmsg'
                    }, {
                        title: 'Resumo de mensagens por CPF',
                        notes: 'Veja quantidade mensagens por CPF',
                        state: 'sms-resmsgcpf'
                    }, {
                        title: 'Pesquisa de SMS',
                        notes: 'Veja um log mais detalhado dos SMS',
                        state: 'sms-pesquisa'
                    }]
                };

                vm.menus.menuZone3 = {
                    items: [{
                        title: 'Upload de SMS',
                        notes: 'Envie arquivos de SMS',
                        state: 'sms-upload'
                    }, {
                        title: 'Processamento de SMS',
                        notes: 'Veja os status dos arquivos processados',
                        state: 'sms-upload-log'
                    }]
                };
                break;

            case 'email':
                vm.menus.menuZone1 = {
                    items: [{
                        title: 'Brokers',
                        notes: 'Brokers são responsáveis pelo envio do e-mail',
                        state: 'email-broker'
                    }, {
                        title: 'Pacotes',
                        notes: 'Gerencie pacotes de e-mail',
                        state: 'email-pacote'
                    }, {
                        title: 'Códigos de e-mail',
                        notes: 'Gerencie códigos de e-mail',
                        state: 'email-codigo'
                    }, {
                        title: 'Variáveis',
                        notes: 'Variáveis disponíveis para e-mail',
                        state: 'email-variavel'
                    }, {
                        title: 'Mensagens',
                        notes: 'Gerencie mensagens de e-mail',
                        state: 'email-mensagem'
                    }, {
                        title: 'Blacklist',
                        notes: 'Gerencie blacklist para e-mail',
                        state: 'email-blacklist'
                    }, {
                        title: 'Parâmetros',
                        notes: 'Defina parâmetros para e-mail',
                        state: 'email-parametro'
                    }]
                };

                vm.menus.menuZone2 = {
                    items: [{
                        title: 'Resumo de mensagens',
                        notes: 'Veja quantidade mensagens por data de movimento',
                        state: 'email-resmsg'
                    }, {
                        title: 'Resumo de mensagens por CPF',
                        notes: 'Veja quantidade mensagens por CPF',
                        state: 'email-resmsgcpf'
                    }, {
                        title: 'Pesquisa de e-mail',
                        notes: 'Veja um log mais detalhado dos e-mail',
                        state: 'email-pesquisa'
                    }]
                };

                vm.menus.menuZone3 = {
                    items: [{
                        title: 'Upload de e-mail',
                        notes: 'Envie arquivos de SMS',
                        state: 'email-upload'
                    }, {
                        title: 'Processamento de e-mail',
                        notes: 'Veja os status dos arquivos processados',
                        state: 'email-upload-log'
                    }]
                };
                break;
        }

        vm.itemClick = function(event) {
            //event.state = 'example';
            $state.go(event.state);
        };
    }
})();