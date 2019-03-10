(function() {
    'use strict';

    angular.module('seeawayApp').controller('AgendaCtrl', AgendaCtrl);

    AgendaCtrl.$inject = ['$scope', '$filter', 'agendaService', 'agenda', '$state'];

    function AgendaCtrl($scope, $filter, agendaService, agenda, $state) {

        var vm = this;
        vm.init = init;
        vm.selectedDate = '';
        vm.prevMonth = prevMonth;
        vm.nextMonth = nextMonth;
        vm.agenda = agenda;
        vm.yearStart = agenda.year;
        vm.monthStart = agenda.month;
        vm.setDayContent = setDayContent;

        function init() {}

        function prevMonth(event) {
            agendaReload(event.year, event.month - 1);
        }

        function nextMonth(event) {
            agendaReload(event.year, event.month - 1);
        }

        function agendaReload(year, month) {
            var date = new Date(year, month, 1);
            $state.go('agenda', { date: date });
        }

        function setDayContent(date) {
            date = moment(date).format('YYYYMMDD');

            if (vm.agenda.eventos.hasOwnProperty(date)) {
                var evento = '<p>' + 'Vencimentos (' + vm.agenda.eventos[date].COUNT + ')';
                evento += '<br />' + numeral(vm.agenda.eventos[date].CB210_VL_VALOR).format('$ 0,0.00');
                evento += '</p>';
                return evento;
            }
        }
    }
})();