// Mostrar/ocultar contraseña
document.addEventListener('DOMContentLoaded', function() {
    const togglePassword = document.getElementById('togglePassword');
    if (togglePassword) {
        togglePassword.addEventListener('click', function() {
            const passwordInput = document.getElementById('password');
            const icon = this.querySelector('i');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        });
    }

    // Ocultar los mensajes de error cuando el usuario empieza a escribir nuevamente
    const dniInput = document.getElementById('dni');
    const passwordInput = document.getElementById('password');
    const dniErrorIcon = document.getElementById('dni-error-icon');
    const passwordErrorIcon = document.getElementById('password-error-icon');
    const dniErrorSmall = document.getElementById('dni-error');
    const passwordErrorSmall = document.getElementById('password-error');

    if (dniInput) {
        dniInput.addEventListener('input', function() {
            dniInput.classList.remove('input-error');
            if (dniErrorIcon) dniErrorIcon.classList.add('hidden');
            if (dniErrorSmall) dniErrorSmall.classList.add('hidden');
        });
    }

    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            passwordInput.classList.remove('input-error');
            if (passwordErrorIcon) passwordErrorIcon.classList.add('hidden');
            if (passwordErrorSmall) passwordErrorSmall.classList.add('hidden');
        });
    }

    // Enviar solicitud de recuperación de contraseña (simulación)
    const sendRecoveryBtn = document.getElementById('sendRecoveryBtn');
    if (sendRecoveryBtn) {
        sendRecoveryBtn.addEventListener('click', function() {
            const form = document.getElementById('forgotPasswordForm');

            if (form.checkValidity()) {
                alert('Se ha enviado un correo con instrucciones para recuperar su contraseña.');

                // Cerrar modal
                $('#forgotPasswordModal').modal('hide');
            } else {
                form.reportValidity();
            }
        });
    }
});