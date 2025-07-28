import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class UsuarioTest {

    @Test
    void testActualizarPesoCorrectamente() {
        Usuario user = new Usuario("César", 70.0);
        user.actualizarPeso(72.5);
        assertEquals(72.5, user.getPeso());
    }

    @Test
    void testMostrarInformacion() {
        Usuario user = new Usuario("César", 70.0);
        assertDoesNotThrow(user::mostrarInformacion);
    }
}
