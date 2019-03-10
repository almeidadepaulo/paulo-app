(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('menu', getState());
    }

    function getState() {
        return {
            url: '/menu/:name',
            templateUrl: 'main/partial/menu/menu.html',
            controller: 'MenuCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                name: 'cadastro',
                index: -1
            }
        };
    }
})();