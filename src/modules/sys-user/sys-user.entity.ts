import {ArrayNotEmpty, IsArray, IsNotEmpty, IsString} from 'class-validator';

export class CreateSystemUserDTO {
    @IsString()
    @IsNotEmpty()
    username: string;

    @IsString()
    @IsNotEmpty()
    password: string;


    @IsString()
    @IsNotEmpty()
    role: string;

    @IsArray()
    @ArrayNotEmpty()
    permissions: string[];

    @IsNotEmpty()
    userId: number;
}
