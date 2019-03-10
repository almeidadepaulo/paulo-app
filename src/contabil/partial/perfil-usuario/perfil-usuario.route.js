(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('perfil-usuario', getState());
    }

    function getState() {
        return {
            url: '/perfil-usuario',
            templateUrl: 'contabil/partial/perfil-usuario/perfil-usuario.html',
            controller: 'PerfilUsuarioCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                id: null,
                tabIndex: 0
            },
        };
    }
})();