(function() {
    'use strict';

    angular
        .module('seeawayApp')
        .factory('toastService', toastService);

    toastService.$inject = ['$mdToast', '$timeout', '$state'];

    function toastService($mdToast, $timeout, $state) {
        var service = {};

        service.message = message;

        return service;

        function message(response) {
            if (response.status === 200) {
                if (response.data.message && response.data.message !== '') {
                    $timeout(function() {
                        $mdToast.show(
                            $mdToast.simple()
                            .textContent(response.data.message)
                            .position('bottom right')
                            .hideDelay(3500)
                        );
                    }, 500);
                }
            } else {
                if (window.location.hostname !== 'localhost' &&
                    (response.data.Message.indexOf('Query') > -1 || response.data.Message.indexOf('undefined') > -1)) {
                    response.data.Message = 'Ops! Ocorreu um erro desconhecido';
                }

                $mdToast.show(
                    $mdToast.simple()
                    .textContent(response.data.Message)
                    .action('Fechar')
                    .highlightAction(true)
                    .highlightClass('md-accent')
                    .position('bottom right')
                    .hideDelay(5000)
                    .theme('error-toast')
                ).then(function(t) {
                    if (t === 'ok' && response.status === 401) {
                        $state.go('login');
                    } else if (t === 'ok' && response.status === 403) {
                        $state.go('home');
                    }
                });
            }
        }
    }

})();