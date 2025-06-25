package junit;

import com.intranet_escolar.util.EmailUtil;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class EmailTest {
    @Test
    public void testEnviarCodigo() {
        String destinatario = "fabriciorr4@gmail.com";
        String codigo = "123456";
        String nombre = "Fabricio Reque";

        assertDoesNotThrow(() -> {
            EmailUtil.enviarCodigo(destinatario, codigo, nombre);
        });
    }
    @Test
    public void testEnviarNuevaClave() {
        String destinatario = "test@gmail.com";
        String nuevaClave = "testl123";
        String nombre = "Juan Pérez";

        assertDoesNotThrow(() -> {
            EmailUtil.enviarNuevaClave(destinatario, nuevaClave, nombre);
        });
    }
}
