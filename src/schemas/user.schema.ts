import {BaseEntity, Column, CreateDateColumn, Entity, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import {SalesRep} from './sales_rep.schema';
import {SystemUsers} from './system_user.schema';
import {Status} from "../utils/enums/status.enum";

@Entity('tbl_user')
export class Employee extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    fullName: string;

    @Column()
    designation: string;

    @Column({ unique: true,nullable: true  })
    nic: string;

    @Column({ type: 'enum', enum: Status, default: Status.ACTIVE })
    status: Status;

    @Column({ nullable: true })
    email: string;

    @Column({ nullable: true })
    phoneNumber: string;

    @OneToMany(() => SalesRep, (salesRep) => salesRep.user)
    salesReps: SalesRep[];

    @OneToMany(() => SystemUsers, (systemUser) => systemUser.user)
    systemUsers: SystemUsers[];

    @CreateDateColumn()
    createdAt: Date;

    @Column()
    createdBy: string;
}
