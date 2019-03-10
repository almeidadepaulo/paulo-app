(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('upload', getState());
    }

    function getState() {
        return {
            url: '/upload',
            templateUrl: 'collect/partial/upload/upload.html',
            controller: 'UploadCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                'id': null
            },
        };
    }
})();