(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];
    /* @ngInject */
    function configure($stateProvider) {
        $stateProvider.state('home', getState());
    }

    function getState() {
        return {
            url: '/home',
            templateUrl: 'main/partial/home/home.html',
            controller: 'HomeCtrl',
            controllerAs: 'vm',
            title: 'Home'
        };
    }
})();