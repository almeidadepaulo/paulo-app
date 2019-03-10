(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .config(configure);

    configure.$inject = ['$stateProvider'];

    function configure($stateProvider) {
        $stateProvider.state('agenda', getState());
    }

    function getState() {
        return {
            url: '/agenda',
            templateUrl: 'epaybox/partial/agenda/agenda.html',
            controller: 'AgendaCtrl',
            controllerAs: 'vm',
            parent: 'home',
            params: {
                date: new Date()
            },
            resolve: {
                agenda: agenda
            }
        };
    }

    agenda.$inject = ['$stateParams', 'agendaService'];

    function agenda($stateParams, agendaService) {

        var date = new Date($stateParams.date.getFullYear(), $stateParams.date.getMonth(), 1);
        var dateFrom = moment(date).add(-1, 'months').toDate();
        var dateTo = moment(date).add(1, 'months').toDate();


        var params = {
            dateFrom: dateFrom,
            dateTo: dateTo
        };

        return agendaService.getBoletoByRange(params)
            .then(function success(response) {
                var result = {};
                result.eventos = {};
                result.year = date.getFullYear();
                result.month = date.getMonth();

                for (var i = 0; i <= response.query.length - 1; i++) {
                    result.eventos[response.query[i].CB210_DT_VCTO] = response.query[i];
                }

                return result;
            }, function error(response) {
                console.error(response);
                return response;
            });
    }
})();