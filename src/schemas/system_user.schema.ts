import {BaseEntity, Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import {Status} from '../utils/enums/status.enum';
import {SalesRep} from './sales_rep.schema';
import {Employee} from "./user.schema";

@Entity('tbl_system_user')
export class SystemUsers extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    username: string;

    @Column()
    password: string;

    @Column({ type: 'enum', enum: Status, default: Status.ACTIVE })
    status: Status;

    @Column()
    role: string;

    @Column({ type: 'json', nullable: true })
    permissions: string[];

    @OneToMany(() => SalesRep, (salesRep) => salesRep.systemUser,{nullable:true})
    salesReps: SalesRep[];

    @ManyToOne(() => Employee, (employee) => employee.systemUsers, { nullable: false })
    user: Employee;
}
