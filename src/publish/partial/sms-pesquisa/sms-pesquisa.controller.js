(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsPesquisaCtrl', SmsPesquisaCtrl);

    SmsPesquisaCtrl.$inject = ['config', 'smsPesquisaService', '$rootScope', '$scope', '$state', '$mdDialog',
        'SMS', 'stringUtil'
    ];

    function SmsPesquisaCtrl(config, smsPesquisaService, $rootScope, $scope, $state, $mdDialog,
        SMS, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.SMS = SMS;
        vm.exportFile = exportFile;
        vm.getData = getData;
        vm.smsPesquisa = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            vm.filter = vm.filter || {};
            //vm.filter.MG002_DT_REMESS = new Date();
            //vm.filter.MG002_DT_REMESS = new Date(2015, 0, 27);
            getData({ reset: true });

            //exportFile();
        }

        function pagination(page, limit) {
            vm.smsPesquisa.data = [];
            getData();
        }

        function exportFile() {
            console.log('exportFile');
            vm.exportFileLoading = true;
            smsPesquisaService.exportFile(vm.filter)
                .then(function success(response) {
                    console.info('exportFile success', response);

                    var blob = stringUtil.toBinary(response.base64, 'application/zip;base64');
                    var blobUrl = URL.createObjectURL(blob);

                    var a = document.createElement('a');
                    document.body.appendChild(a);
                    a.style = 'display: none';
                    a.href = blobUrl;
                    a.download = 'SMS Pesquisa.zip';
                    a.click();
                    window.URL.revokeObjectURL(blobUrl);

                    vm.exportFileLoading = false;
                }, function error(response) {
                    vm.exportFileLoading = false;
                    console.error('error', response);
                });
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsPesquisa.page;
            vm.filter.limit = vm.smsPesquisa.limit;

            if (params.reset) {
                vm.smsPesquisa.data = [];
            }

            vm.smsPesquisa.promise = smsPesquisaService.get(vm.filter)
                .then(function success(response) {
                    console.info('success', response);
                    vm.smsPesquisa.total = response.recordCount;
                    vm.smsPesquisa.data = vm.smsPesquisa.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

    }

})();