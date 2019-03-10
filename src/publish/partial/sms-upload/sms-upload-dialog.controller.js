(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsUploadDialogCtrl', SmsUploadDialogCtrl);

    SmsUploadDialogCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsUploadDialogCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;

        vm.close = close;
        vm.dgExemploControl = {};
        vm.dgExemploInit = dgExemploInit;
        vm.dgExemploConfig = {
            //url: config.REST_URL + '/example',
            method: 'GET',
            fields: [{
                pk: true,
                title: 'EM805_NR_INST',
                field: 'EM805_NR_INST',
                type: 'numeric',
                visible: false
            }, {
                pk: true,
                title: 'EM805_CD_EMIEMP',
                field: 'EM805_CD_EMIEMP',
                type: 'numeric',
                visible: false
            }, {
                pk: true,
                title: 'EM805_NR_GERAC',
                field: 'EM805_NR_GERAC',
                type: 'numeric',
                visible: false
            }, {
                title: 'Nome',
                field: 'EM805_NM_ARQ',
                type: 'varchar'
            }, {
                title: 'Data',
                field: 'EM805_DT_PROC',
                type: 'numeric',
                moment: 'dddd - DD/MM/YYYY'
            }, {
                title: 'Hr. Processamento',
                field: 'EM805_HR_PROC_LABEL',
                type: 'varchar'
            }, {
                title: 'Status',
                field: 'EM805_ID_STATUS_LABEL',
                type: 'varchar',
            }, {
                title: 'Usuário',
                field: 'usu_nome',
                type: 'varchar',
            }]
        };

        function dgExemploInit() {
            getData();
        }

        function getData() {
            // fake
            var row = {
                EM805_NR_INST: 1,
                EM805_CD_EMIEMP: 1,
                EM805_NR_GERAC: 1,
                EM805_NM_ARQ: 'Arquivo',
                EM805_DT_PROC: new Date(),
                EM805_HR_PROC_LABEL: moment().format('HH:mm:ss'),
                EM805_ID_STATUS_LABEL: 'DEMONSTRAÇÃO - UPLOAD',
                'usu_nome': $rootScope.globals.currentUser.nome
            };

            vm.dgExemploControl.addDataRow(row);

            //$scope.dgExemploControl.getData();
        }

        function close() {
            $mdDialog.cancel();
        }
    }
})();