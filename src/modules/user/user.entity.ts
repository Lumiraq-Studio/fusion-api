export interface CreateUserDTO {
    fullName: string;
    designation: string;
    nic: string;
    email: string;
    mobile: string;
    createdBy: string;
}

export interface UpdateUserDTO extends Partial<CreateUserDTO> {
}


