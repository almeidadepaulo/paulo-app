(function() {
    'use strict';

    angular.module('seeawayApp').directive('compareTo', compareTo);

    compareTo.$inject = [];

    function compareTo() {
        var directive = {
            require: 'ngModel',
            scope: {
                otherModelValue: '=compareTo'
            },
            link: link
        };
        return directive;

        function link(scope, element, attrs, ngModel) {
            ngModel.$validators.compareTo = function(modelValue) {
                return modelValue === scope.otherModelValue;
            };

            scope.$watch('otherModelValue', function() {
                ngModel.$validate();
            });
        }
    }
})();