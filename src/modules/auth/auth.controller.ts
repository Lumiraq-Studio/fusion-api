import {Body, Controller, Post} from '@nestjs/common';
import {AuthService} from './auth.service';
import {LoginDTO} from "./auth.entity";

@Controller()
export class AuthController {
    constructor(private readonly authService: AuthService) {
    }

    @Post('login')
    async login(@Body() loginDto: LoginDTO) {
        return this.authService.login(loginDto.username, loginDto.password);
    }
}
