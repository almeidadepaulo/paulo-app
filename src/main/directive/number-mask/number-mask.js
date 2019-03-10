(function() {
    'use strict';

    angular.module('seeawayApp').directive('numberMask', numberMask);

    numberMask.$inject = ['$locale'];

    function numberMask($locale) {
        var directive = {
            restrict: 'A',
            scope: {
                cleanValue: '@cleanValue',
                currency: '=pxCurrency',
                currencySymbol: '@pxCurrencySymbol',
                numberSuffix: '@pxNumberSuffix',
                decimalSeparator: '@pxDecimalSeparator',
                thousandsSeparator: '@pxThousandsSeparator',
                numberPrecision: '@pxNumberPrecision',
                useNegative: '=pxUseNegative',
                usePositiveSymbol: '=pxUsePositiveSymbol'
            },
            require: '?ngModel',
            link: link
        };
        return directive;

        function link(scope, element, attrs, ngModel) { // jshint ignore:line
            element.css({
                zIndex: 0
            });

            if (!ngModel) {
                return;
            }

            // Número habilitados
            var enableNumbers = /[0-9]/;
            // Define se o valor será moeda
            var currency = scope.pxCurrency || false;
            // Define símbolo do valor moeda
            var currencySymbol = scope.currencySymbol || '';
            // Define sufixo
            var numberSuffix = scope.numberSuffix || '';
            // Separador de decimal
            var decimalSeparator = scope.decimalSeparator || $locale.NUMBER_FORMATS.DECIMAL_SEP;
            // Separador de milhar
            var thousandsSeparator = scope.thousandsSeparator || $locale.NUMBER_FORMATS.GROUP_SEP;
            // Número de casas decimais
            var numberPrecision = Number(scope.numberPrecision) || 2;
            // Habilitar uso de número negativos
            var useNegative = scope.useNegative || false;
            // Usar símbolo positivo (+)
            var usePositiveSymbol = scope.usePositiveSymbol || false;

            if (currency && currencySymbol === '') {
                currencySymbol = $locale.NUMBER_FORMATS.CURRENCY_SYM;
            }

            var limit = false;
            var emptyValue = true;

            ngModel.$parsers.push(function(value) {

                var clean = '';
                if (value !== '0' && (value !== '' || emptyValue === false)) {
                    clean = numberFormatter(value);
                } else if (value.trim() === '0' && emptyValue === true) {
                    return 0;
                } else {
                    emptyValue = true;
                    return '';
                }
                if (value !== clean) {
                    ngModel.$setViewValue(clean);
                    ngModel.$render();
                }

                if (isNaN(numeral().unformat(clean))) {
                    return 0;
                } else {
                    return numeral().unformat(clean);
                }
            });

            function toNumber(str) {
                var formatted = '';
                for (var i = 0; i < (str.length); i++) {
                    var char_ = str.charAt(i);
                    if (formatted.length === 0 && char_ === '0') {
                        char_ = false;
                    }
                    if (char_ && char_.match(enableNumbers)) {
                        if (limit) {
                            if (formatted.length < limit) {
                                formatted = formatted + char_;
                            }
                        } else {
                            formatted = formatted + char_;
                        }
                    }
                }
                return formatted;
            }

            function fillWithZero(str) {
                if (str === '') {
                    return str;
                }

                while (str.length < (numberPrecision + 1)) {
                    str = '0' + str;
                }
                return str;
            }

            function numberFormatter(str) { // jshint ignore:line

                if (str === '') {
                    emptyValue = true;
                    return str;
                } else if (str === (currencySymbol + $locale.NUMBER_FORMATS.DECIMAL_SEP)) {
                    return '0';
                }

                //emptyValue = false;


                var formatted = fillWithZero(toNumber(str));
                var thousandsFormatted = '';
                var thousandsCount = 0;

                var centsVal;
                if (numberPrecision === 0) {
                    decimalSeparator = '';
                    centsVal = '';
                }
                centsVal = formatted.substr(formatted.length - numberPrecision, numberPrecision);
                var integerVal = formatted.substr(0, formatted.length - numberPrecision);
                formatted = (numberPrecision === 0) ? integerVal : integerVal + decimalSeparator + centsVal;
                if (thousandsSeparator || $.trim(thousandsSeparator) !== '') {
                    for (var j = integerVal.length; j > 0; j--) {
                        var char_ = integerVal.substr(j - 1, 1);
                        thousandsCount++;
                        if (thousandsCount % 3 === 0) {
                            char_ = thousandsSeparator + char_;
                        }
                        thousandsFormatted = char_ + thousandsFormatted;
                    }
                    if (thousandsFormatted.substr(0, 1) === thousandsSeparator) {
                        thousandsFormatted = thousandsFormatted.substring(1, thousandsFormatted.length);
                    }
                    formatted = (numberPrecision === 0) ? thousandsFormatted : thousandsFormatted + decimalSeparator + centsVal;
                }
                if (useNegative && (integerVal !== 0 || centsVal !== 0)) {
                    if (str.indexOf('-') !== -1 && str.indexOf('+') < str.indexOf('-')) {
                        formatted = '-' + formatted;
                    } else {
                        if (!usePositiveSymbol) {
                            formatted = '' + formatted;
                        } else {
                            formatted = '+' + formatted;
                        }
                    }
                }
                if (currencySymbol) {
                    formatted = currencySymbol + formatted;
                }
                if (numberSuffix) {
                    formatted = formatted + numberSuffix;
                }
                return formatted;
            }
        }
    }
})();