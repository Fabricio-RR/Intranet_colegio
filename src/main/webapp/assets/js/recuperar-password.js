// Función global para cambiar entre pasos
function goToStep(step) {
    document.getElementById('paso1').style.display = step === 1 ? 'block' : 'none';
    document.getElementById('paso2').style.display = step === 2 ? 'block' : 'none';
    document.getElementById('paso3').style.display = step === 3 ? 'block' : 'none';

    document.querySelectorAll('.step').forEach((el, idx) => {
        el.classList.toggle('active', idx + 1 === step);
    });
}

// Función global para el temporizador
function iniciarTemporizador(segundos) {
    const countdown = document.getElementById('countdown');
    let tiempo = segundos;

    const intervalo = setInterval(() => {
        const minutos = String(Math.floor(tiempo / 60)).padStart(2, '0');
        const segs = String(tiempo % 60).padStart(2, '0');
        countdown.textContent = `El código expira en: ${minutos}:${segs}`;
        tiempo--;

        if (tiempo < 0) {
            clearInterval(intervalo);
            countdown.textContent = "El código ha expirado.";
        }
    }, 1000);
}

document.addEventListener('DOMContentLoaded', function () {
    let currentStep = 1;

    const btnPaso1 = document.getElementById('btnPaso1');
    const btnPaso2 = document.getElementById('btnPaso2');
    const btnPaso3 = document.getElementById('btnPaso3');
    const btnVolverPaso1 = document.getElementById('btnVolverPaso1');
    const btnVolverPaso2 = document.getElementById('btnVolverPaso2');

    const dniInput = document.getElementById('dni');
    const emailInput = document.getElementById('email');
    const codeInputs = document.querySelectorAll('.code-input');
    const newPasswordInput = document.getElementById('newPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');

    const passwordStrength = document.getElementById('passwordStrength');
    const passwordFeedback = document.getElementById('passwordFeedback');

    document.getElementById('toggleNewPassword').addEventListener('click', togglePasswordVisibility);
    document.getElementById('toggleConfirmPassword').addEventListener('click', togglePasswordVisibility);

    function togglePasswordVisibility(e) {
        const input = e.target.closest('.input-group').querySelector('input');
        const icon = e.target.closest('button').querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    btnPaso1.addEventListener('click', function () {
        const dni = dniInput.value.trim();
        const email = emailInput.value.trim();

        if (dni === '' || email === '') {
            return;
        }

        const dniValido = /^\d{8}$/.test(dni);
        const emailValido = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

        if (!dniValido) {
            dniInput.focus();
            return;
        }

        if (!emailValido) {
            emailInput.focus();
            return;
        }

    });

    btnPaso2.addEventListener('click', function () {
        let codigo = "";
        codeInputs.forEach(input => codigo += input.value.trim());
        if (/^\d{6}$/.test(codigo)) {
            document.getElementById('codigoInput').value = codigo;
            document.getElementById('formPaso2').submit();
        } else {
            alert('El código debe tener 6 dígitos numéricos.');
        }
    });

    newPasswordInput.addEventListener('input', function () {
        const value = newPasswordInput.value;
        const score = evaluarSeguridad(value);
        passwordStrength.style.width = `${score}%`;
        passwordStrength.className = 'progress-bar';

        if (score < 40) {
            passwordStrength.classList.add('bg-danger');
            passwordFeedback.textContent = 'Contraseña débil.';
        } else if (score < 70) {
            passwordStrength.classList.add('bg-warning');
            passwordFeedback.textContent = 'Contraseña aceptable.';
        } else {
            passwordStrength.classList.add('bg-success');
            passwordFeedback.textContent = 'Contraseña fuerte.';
        }
    });

    btnPaso3.addEventListener('click', function (e) {
        if (newPasswordInput.value !== confirmPasswordInput.value) {
            e.preventDefault();
            
        }
    });

    btnVolverPaso1.addEventListener('click', () => goToStep(1));
    btnVolverPaso2.addEventListener('click', () => goToStep(2));

    codeInputs.forEach((input, idx) => {
        input.addEventListener('input', function () {
            if (input.value.length === 1 && idx < codeInputs.length - 1) {
                codeInputs[idx + 1].focus();
            }
        });
    });

    function evaluarSeguridad(password) {
        let score = 0;
        if (password.length >= 8) score += 20;
        if (/[a-z]/.test(password)) score += 20;
        if (/[A-Z]/.test(password)) score += 20;
        if (/\d/.test(password)) score += 20;
        if (/[\W_]/.test(password)) score += 20;
        return score;
    }
});
