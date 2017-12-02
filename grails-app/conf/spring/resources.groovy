import com.ybg.dsh.listener.UserPasswordEncoderListener
import com.ybg.dsh.sys.SystemUserDetailsService

// Place your Spring DSL code here
beans = {
    userDetailsService(SystemUserDetailsService)
    userPasswordEncoderListener(UserPasswordEncoderListener)
}
