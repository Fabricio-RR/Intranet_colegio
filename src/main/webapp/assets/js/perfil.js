document.addEventListener('DOMContentLoaded', function() {
    // Navegación entre pasos
    const btnPaso1 = document.getElementById('btnPaso1');
    if (btnPaso1) {
        btnPaso1.addEventListener('click', function() {
            const dni = document.getElementById('dni').value;
            const email = document.getElementById('email').value;
            
            if (!dni || !email) {
                alert('Por favor, completa todos los campos.');
                return;
            }
            
            // Simulación de envío de código (aquí iría la llamada AJAX real)
            setTimeout(function() {
                document.getElementById('paso1').style.display = 'none';
                document.getElementById('paso2').style.display = 'block';
                document.getElementById('step1').classList.remove('active');
                document.getElementById('step1').classList.add('completed');
                document.getElementById('step2').classList.add('active');
                
                // Iniciar cuenta regresiva
                startCountdown(5 * 60); // 5 minutos
            }, 1000);
        });
    }
    
    const btnPaso2 = document.getElementById('btnPaso2');
    if (btnPaso2) {
        btnPaso2.addEventListener('click', function() {
            let code = '';
            const codeInputs = document.querySelectorAll('.code-input');
            codeInputs.forEach(function(input) {
                code += input.value;
            });
            
            if (code.length !== 6) {
                alert('Por favor, ingresa el código completo de 6 dígitos.');
                return;
            }
            
            // Simulación de verificación (aquí iría la llamada AJAX real)
            setTimeout(function() {
                document.getElementById('paso2').style.display = 'none';
                document.getElementById('paso3').style.display = 'block';
                document.getElementById('step2').classList.remove('active');
                document.getElementById('step2').classList.add('completed');
                document.getElementById('step3').classList.add('active');
                
                // Establecer token (simulado)
                document.getElementById('token').value = 'token-simulado-' + new Date().getTime();
            }, 1000);
        });
    }
    
    const btnVolverPaso1 = document.getElementById('btnVolverPaso1');
    if (btnVolverPaso1) {
        btnVolverPaso1.addEventListener('click', function() {
            document.getElementById('paso2').style.display = 'none';
            document.getElementById('paso1').style.display = 'block';
            document.getElementById('step2').classList.remove('active');
            document.getElementById('step1').classList.remove('completed');
            document.getElementById('step1').classList.add('active');
        });
    }
    
    const btnVolverPaso2 = document.getElementById('btnVolverPaso2');
    if (btnVolverPaso2) {
        btnVolverPaso2.addEventListener('click', function() {
            document.getElementById('paso3').style.display = 'none';
            document.getElementById('paso2').style.display = 'block';
            document.getElementById('step3').classList.remove('active');
            document.getElementById('step2').classList.remove('completed');
            document.getElementById('step2').classList.add('active');
        });
    }
    
    const btnReenviarCodigo = document.getElementById('btnReenviarCodigo');
    if (btnReenviarCodigo) {
        btnReenviarCodigo.addEventListener('click', function() {
            // Simulación de reenvío (aquí iría la llamada AJAX real)
            alert('Se ha reenviado el código de verificación a tu correo electrónico.');
            
            // Reiniciar cuenta regresiva
            startCountdown(5 * 60); // 5 minutos
        });
    }
    
    // Manejo de inputs de código de verificación
    const codeInputs = document.querySelectorAll('.code-input');
    codeInputs.forEach(function(input, index) {
        input.addEventListener('input', function() {
            const maxLength = parseInt(this.getAttribute('maxlength'));
            const currentLength = this.value.length;
            
            if (currentLength >= maxLength && index < codeInputs.length - 1) {
                codeInputs[index + 1].focus();
            }
        });
        
        input.addEventListener('keydown', function(e) {
            // Si se presiona Backspace y el campo está vacío, enfocar el campo anterior
            if (e.key === 'Backspace' && this.value === '' && index > 0) {
                codeInputs[index - 1].focus();
            }
        });
    });
    
    // Toggle para mostrar/ocultar contraseñas
    const toggleNewPassword = document.getElementById('toggleNewPassword');
    if (toggleNewPassword) {
        toggleNewPassword.addEventListener('click', function() {
            togglePasswordVisibility('newPassword', this);
        });
    }
    
    const toggleConfirmPassword = document.getElementById('toggleConfirmPassword');
    if (toggleConfirmPassword) {
        toggleConfirmPassword.addEventListener('click', function() {
            togglePasswordVisibility('confirmPassword', this);
        });
    }
    
    // Validación de contraseña
    const newPassword = document.getElementById('newPassword');
    if (newPassword) {
        newPassword.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;
            
            // Longitud mínima
            if (password.length >= 8) strength += 25;
            
            // Contiene letras minúsculas
            if (/[a-z]/.test(password)) strength += 25;
            
            // Contiene letras mayúsculas
            if (/[A-Z]/.test(password)) strength += 25;
            
            // Contiene números o caracteres especiales
            if (/[0-9!@#$%^&*(),.?":{}|<>]/.test(password)) strength += 25;
            
            // Actualizar barra de progreso
            const strengthBar = document.getElementById('passwordStrength');
            strengthBar.style.width = strength + '%';
            
            // Cambiar color según fortaleza
            strengthBar.className = 'progress-bar';
            if (strength <= 25) {
                strengthBar.classList.add('bg-danger');
                document.getElementById('passwordFeedback').textContent = 'Contraseña débil. Añade más caracteres y variedad.';
            } else if (strength <= 50) {
                strengthBar.classList.add('bg-warning');
                document.getElementById('passwordFeedback').textContent = 'Contraseña moderada. Intenta añadir más variedad.';
            } else if (strength <= 75) {
                strengthBar.classList.add('bg-info');
                document.getElementById('passwordFeedback').textContent = 'Contraseña buena. Casi allí.';
            } else {
                strengthBar.classList.add('bg-success');
                document.getElementById('passwordFeedback').textContent = 'Contraseña fuerte. ¡Excelente!';
            }
        });
    }
    
    // Validación de confirmación de contraseña
    const formPaso3 = document.getElementById('formPaso3');
    if (formPaso3) {
        formPaso3.addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Las contraseñas no coinciden. Por favor, verifica.');
            }
        });
    }
    
    // Función para la cuenta regresiva
    function startCountdown(seconds) {
        let timer = seconds;
        const countdownElement = document.getElementById('countdown');
        if (!countdownElement) return;
        
        const interval = setInterval(function() {
            const minutes = Math.floor(timer / 60);
            const seconds = timer % 60;
            
            countdownElement.textContent = 'El código expira en: ' + 
                (minutes < 10 ? '0' : '') + minutes + ':' + 
                (seconds < 10 ? '0' : '') + seconds;
            
            if (--timer < 0) {
                clearInterval(interval);
                countdownElement.textContent = 'El código ha expirado. Por favor, solicita uno nuevo.';
                const btnPaso2 = document.getElementById('btnPaso2');
                if (btnPaso2) btnPaso2.disabled = true;
            }
        }, 1000);
    }
    
    // Función para mostrar/ocultar contraseña
    function togglePasswordVisibility(inputId, button) {
        const passwordInput = document.getElementById(inputId);
        const icon = button.querySelector('i');
        
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
});