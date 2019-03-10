(function() {
    'use strict';

    angular.module('seeawayApp').controller('SegundaViaPdfDialogCtrl', SegundaViaPdfDialogCtrl);

    SegundaViaPdfDialogCtrl.$inject = ['config', 'segundaViaService', '$rootScope', '$scope', '$state', '$mdDialog',
        'locals', 'stringUtil'
    ];

    function SegundaViaPdfDialogCtrl(config, segundaViaService, $rootScope, $scope, $state, $mdDialog,
        locals, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.sendEmail = sendEmail;
        vm.cancel = cancel;

        function init(event) {
            vm.loading = true;
            vm.email = locals.items[0].CB201_NM_EMAIL.trim();
            getData();
        }

        function getData() {
            segundaViaService.pdf(locals)
                .then(function success(response) {
                    console.info('getBlobByProtocolo', response);

                    var blob = stringUtil.toBinary(response.base64, 'application/pdf;base64');
                    var blobUrl = URL.createObjectURL(blob);

                    vm.pathPdf = 'pdf-viewer/web/viewer.cfm?file=' + blobUrl;
                    vm.loading = false;
                }, function error(error) {
                    vm.loading = false;
                    console.error(error);
                });
        }

        function sendEmail() {
            vm.loading = true;
            locals.email = vm.email;

            segundaViaService.pdfEmail(locals)
                .then(function success(response) {
                    console.info('pdfEmail', response);
                    vm.loading = false;
                }, function error(error) {
                    vm.loading = false;
                    console.error(error);
                });
        }

        function cancel() {
            $mdDialog.cancel();
        }
    }
})();