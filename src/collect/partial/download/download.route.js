(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('download', getState());
    }

    function getState() {
        return {
            url: '/download',
            templateUrl: 'collect/partial/download/download.html',
            controller: 'DownloadCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();