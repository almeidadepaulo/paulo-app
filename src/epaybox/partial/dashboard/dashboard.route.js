(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('dashboard', getState());
    }

    function getState() {
        return {
            url: '/dashboard',
            templateUrl: 'epaybox/partial/dashboard/dashboard.html',
            controller: 'DashboardCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                id: null
            },
            resolve: {
                getBoletoStatus: getBoletoStatus
            }
        };
    }

    getBoletoStatus.$inject = ['dashboardService'];

    function getBoletoStatus(dashboardService) {
        return dashboardService.getBoletoStatus()
            .then(function success(response) {
                console.info(response);
                return response;
            }, function error(response) {
                console.error(response);
            });
    }
})();