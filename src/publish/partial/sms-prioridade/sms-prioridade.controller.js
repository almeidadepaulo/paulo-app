(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsPrioridadeCtrl', SmsPrioridadeCtrl);

    SmsPrioridadeCtrl.$inject = ['config', 'smsPrioridadeService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsPrioridadeCtrl(config, smsPrioridadeService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.setPrioridadeSms = setPrioridadeSms;
        vm.moveUp = moveUp;
        vm.moveDown = moveDown;

        function init() {
            getData();
        }

        function getData() {

            smsPrioridadeService.get()
                .then(function success(response) {
                    var len = response.query.length;
                    var lenReverse = 0;
                    for (var i = 0; i < response.query.length; i++) {
                        response.query[i].MG057_NR_SEQ = i + 1;
                        response.query[i].selected = false;
                        response.query[i].MG057_NR_SEQ_OLD = '';
                    }
                    vm.prioridade = response.query;
                    vm.prioridade.sort(sortOn('MG057_NR_SEQ', false, parseInt));
                }, function error(response) {
                    console.error('error', response);
                });

        }

        function setPrioridadeSms(event) {
            var data = {
                codSms: vm.prioridade
            };
            smsPrioridadeService.create(data)
                .then(function success(response) {
                    getData();
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function moveUp(event) {
            //console.info('moveUp', vm.prioridade);
            for (var i = 0; i < vm.prioridade.length; i++) {
                //console.info('vm.prioridade', vm.prioridade[i]);
                if (angular.isDefined(vm.prioridade[i - 1]) && vm.prioridade[i].selected) {
                    if (vm.prioridade[i].MG057_NR_SEQ_OLD === '') {
                        vm.prioridade[i].MG057_NR_SEQ_OLD = vm.prioridade[i].MG057_NR_SEQ;
                    }
                    vm.prioridade[i].MG057_NR_SEQ--;

                    if (vm.prioridade[i - 1].MG057_NR_SEQ_OLD === '') {
                        vm.prioridade[i - 1].MG057_NR_SEQ_OLD = vm.prioridade[i - 1].MG057_NR_SEQ;
                    }
                    vm.prioridade[i - 1].MG057_NR_SEQ++;
                }
                //vm.prioridade[i].selected = false
                vm.prioridade.sort(sortOn('MG057_NR_SEQ', false, parseInt));
            }

            //91.info('moveUp', vm.prioridade);
        }

        function moveDown(event) {
            //console.info('moveDown', vm.prioridade);
            for (var i = vm.prioridade.length - 1; i >= 0; i--) {
                //console.info('vm.prioridade', vm.prioridade[i]);
                if (angular.isDefined(vm.prioridade[i + 1]) && vm.prioridade[i].selected) {
                    if (vm.prioridade[i].MG057_NR_SEQ_OLD === '') {
                        vm.prioridade[i].MG057_NR_SEQ_OLD = vm.prioridade[i].MG057_NR_SEQ;
                    }
                    vm.prioridade[i].MG057_NR_SEQ++;

                    if (vm.prioridade[i + 1].MG057_NR_SEQ_OLD === '') {
                        vm.prioridade[i + 1].MG057_NR_SEQ_OLD = vm.prioridade[i + 1].MG057_NR_SEQ;
                    }
                    vm.prioridade[i + 1].MG057_NR_SEQ--;
                }
                //vm.prioridade[i].selected = false
                vm.prioridade.sort(sortOn('MG057_NR_SEQ', false, parseInt));
            }
        }

        function sortOn(field, reverse, primer) {

            var key = primer ?
                function(x) {
                    return primer(x[field]);
                } :
                function(x) {
                    return x[field];
                };

            reverse = !reverse ? 1 : -1;

            return function(a, b) {
                return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
            };
        }
    }
})();