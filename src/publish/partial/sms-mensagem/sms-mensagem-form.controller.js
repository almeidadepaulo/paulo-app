(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsMensagemFormCtrl', SmsMensagemFormCtrl);

    SmsMensagemFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'smsMensagemService', 'getData',
        'smsVariavelService', '$scope', '$rootScope'
    ];

    function SmsMensagemFormCtrl($state, $stateParams, $mdDialog, smsMensagemService, getData, smsVariavelService, $scope, $rootScope) {

        var vm = this;
        vm.init = init;
        vm.mensagem = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.codigoDialog = codigoDialog;
        vm.getVariavelSms = getVariavelSms;

        vm.variaveis = [{
            MG060_DS_VAR: 'Preencha o campo Grupo e Cedente para carregar as variáveis',
            needLoad: true
        }];

        // Quantidade de caracteres disponíveis para a mensagem
        vm.MENSAGEM_MAX_LENGTH = 140;

        // Armazena varáveis disponíveis
        $scope.variaveis = [];

        // Array das varáveis que serão substituídas para cálculo caracteres
        $scope.variaveisReplace = [];

        // Map variáveis
        $scope.variaveisMap = {};

        // Quantidade de caracteres disponíveis para a mensagem
        vm.mensagem.MG061_QT_CARACT = 0;

        function init() {
            vm.aprovador = $rootScope.globals.currentUser.smsAprovador;
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.MG061_CD_CODSMS = parseInt(vm.getData.MG061_CD_CODSMS);
                vm.mensagem = vm.getData;
            } else {
                vm.action = 'create';
                vm.mensagem.MG061_ID_STATUS = 0;
                vm.mensagem.MG061_QT_CARACT = 0;
            }

            getVariavelSms();
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                smsMensagemService.removeById($stateParams.id)
                    .then(function success(response) {
                        //console.info('success', response);
                        $state.go('sms-mensagem');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('sms-mensagem');
        }

        function save() {

            // fix aprovador permissao
            vm.mensagem.MG061_ID_ATIVO = (vm.mensagem.MG061_ID_STATUS === 1) ? 1 : 2;

            if ($stateParams.id) {
                //update
                smsMensagemService.update($stateParams.id, vm.mensagem)
                    .then(function success(response) {
                        //console.info('success', response);
                        $state.go('sms-mensagem');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                smsMensagemService.create(vm.mensagem)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('sms-mensagem');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function codigoDialog() {
            $mdDialog.show({
                locals: {},
                preserveScope: true,
                controller: 'SmsCodigoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'publish/partial/sms-codigo/sms-codigo-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                console.info(data);
                vm.mensagem.MG061_CD_CODSMS = data.MG055_CD_CODSMS;
                vm.mensagem.MG055_DS_CODSMS = data.MG055_DS_CODSMS;
            });
        }

        //
        function getVariavelSms() {
            vm.filter = vm.filter || {};
            vm.filter.page = 1;
            vm.filter.limit = 100; // fix!

            vm.variaveisMap = {};

            smsVariavelService.get(vm.filter)
                .then(function success(response) {
                    if (angular.isDefined(vm.mensagem.MG061_DS_TEXTO) && (vm.mensagem.formAction === 'update' || vm.variaveis[0].needLoad)) {
                        document.getElementById('mensagem').innerText = vm.mensagem.MG061_DS_TEXTO;
                    }

                    if (response.query.length > 0) {
                        vm.variaveis = response.query;

                        vm.variaveisReplace = vm.variaveis.map(function(value, index) {
                            // Criar chave para Map, susbstituir \ por ''
                            // Ex.: \nome\ -> nome
                            var key = value.MG060_CD_VAR.replace(new RegExp('\\\\', 'g'), '');
                            vm.variaveisMap[key] = {
                                length: value.MG060_QT_CARAC
                            };
                            return '\\' + value.MG060_CD_VAR + '\\';
                        });
                    }

                    if (angular.isDefined(vm.mensagem.MG061_DS_TEXTO) && (vm.action = 'update' || $scope.variaveis[0].needLoad === true)) {
                        document.getElementById('mensagem').innerText = vm.mensagem.MG061_DS_TEXTO;
                    }

                    if (response.query.length > 0) {
                        $scope.variaveis = response.query;

                        $scope.variaveisReplace = $scope.variaveis.map(function(value, index) {
                            // Criar chave para Map, susbstituir \ por ''
                            // Ex.: \nome\ -> nome
                            var key = value.MG060_CD_VAR.replace(new RegExp('\\\\', 'g'), '');
                            $scope.variaveisMap[key] = {
                                length: value.MG060_QT_CARAC
                            };
                            return '\\' + value.MG060_CD_VAR + '\\';
                        });
                    }


                    $scope.setMensagem();
                    $scope.mensagemBlur();
                }, function error(response) {
                    console.error('error', response);
                });
        }

        // mensagem fix $scope->vm

        // Posição cursor
        $scope.caretPosition = 0;

        $scope.mensagemBlur = function(event) {
            var element = document.getElementById('mensagem');
            $scope.caretPosition = getCaretPosition(element);
            if ($scope.mensagemHtml) {
                element.innerHTML = $scope.mensagemHtml;
            }
        };

        $scope.mensagemFocus = function(event) {
            var element = document.getElementById('mensagem');
            element.innerHtml = element.innerText;
            element.innerText = element.innerHtml;
        };

        $scope.setMensagem = function(event) {
            //console.info('setMensagem', event);            

            var element = document.getElementById('mensagem');

            if ($scope.variaveis.length === 0) {
                return;
            }

            // Mensagem que o usuário digitou
            // Esta mensagem será usada para cálculo de caracteres e para criar o html text
            var mensagemDigitada = element.innerText;
            //mensagemDigitada = 'teste \\ANIV-ADIC\\';

            // Quantidade de caracteres disponíveis para a mensagem
            vm.mensagem.MG061_QT_CARACT = 0;

            // http://jsfiddle.net/L6LB2/1/
            var re = new RegExp($scope.variaveisReplace.join('|'), 'gi');

            // Criar html text
            $scope.mensagemHtml = mensagemDigitada.replace(re, function(matched) {
                return '<span class="tag">' + matched + '</span>';
            });

            // Substituir e calcular variavéis            
            mensagemDigitada = mensagemDigitada.replace(re, function(matched) {
                var key = matched.replace(new RegExp('\\\\', 'g'), '');
                vm.mensagem.MG061_QT_CARACT += parseInt($scope.variaveisMap[key].length);
                return '';
            });

            //var caret = getCaretPosition(element);

            vm.mensagem.MG061_QT_CARACT += mensagemDigitada.length;
            //element.innerHTML = mensagemHtml;

            /*
            console.info('mensagemDigitada', mensagemDigitada);
            console.info('mensagemHtml', mensagemHtml);
            console.info('childNodes', element.childNodes);
            console.info('element', element.nodeName);
            console.info('caret', caret);

            setCaretPosition(element, caret);
            */

            vm.mensagem.MG061_DS_TEXTO = element.innerText;

            vm.form.MG061_QT_CARACT.$setTouched();

            /*if (vm.form.$invalid) {
                angular.forEach(vm.form.$error, function(field) {
                    angular.forEach(field, function(errorField) {
                        errorField.$setTouched();
                    });
                });
            }*/
        };

        $scope.variavelClick = function(event, value) {
            //console.info('variavelClick');

            if ($scope.variaveis[0].needLoad === true) {
                return;
            }

            var element = document.getElementById('mensagem');

            // Mensagem que o usuário digitou            
            var mensagemDigitada = element.innerText;

            //console.info('$scope.caretPosition', $scope.caretPosition);
            //console.info('mensagemDigitada', mensagemDigitada);

            mensagemDigitada = mensagemDigitada.substring(0, $scope.caretPosition) + value + mensagemDigitada.substring($scope.caretPosition, mensagemDigitada.length);

            element.innerText = mensagemDigitada;
            $scope.setMensagem();
            setCaretPosition(element, $scope.caretPosition + value.length);

        };

        // http://stackoverflow.com/questions/3972014/get-caret-position-in-contenteditable-div
        function getCaretPosition(element) {
            var caretOffset = 0;
            if (typeof window.getSelection !== 'undefined' && window.getSelection().rangeCount > 0) {
                var range = window.getSelection().getRangeAt(0);
                var preCaretRange = range.cloneRange();
                preCaretRange.selectNodeContents(element);
                preCaretRange.setEnd(range.endContainer, range.endOffset);
                caretOffset = preCaretRange.toString().length;
            } else if (typeof document.selection !== 'undefined' && document.selection.type !== 'Control') {
                var textRange = document.selection.createRange();
                var preCaretTextRange = document.body.createTextRange();
                preCaretTextRange.moveToElementText(element);
                preCaretTextRange.setEndPoint('EndToEnd', textRange);
                caretOffset = preCaretTextRange.text.length;
            }
            return caretOffset;
        }


        function setCaretPosition(element, caret) {
            var el = element;
            var range = document.createRange();
            var sel = window.getSelection();

            var nodeIndex = 0;

            /*
            while (element.childNodes[nodeIndex].length < caret){                
                caret = caret-element.childNodes[nodeIndex].length-element.childNodes[nodeIndex+1].innerText.length;
                nodeIndex += 2;                
            }
            */

            range.setStart(element.childNodes[nodeIndex], caret);
            range.collapse(true);
            sel.removeAllRanges();
            sel.addRange(range);
            el.focus();
        }
    }
})();