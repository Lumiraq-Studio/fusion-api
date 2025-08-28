import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    ManyToOne,
    OneToMany,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';
import {Employee} from './user.schema';
import {Order} from './order.schema';
import {Expense} from './expense.schema';
import {Vehicle} from './vehicle.schema';
import {Status} from '../utils/enums/status.enum';
import {SystemUsers} from './system_user.schema';

@Entity('tbl_sales_rep')
export class SalesRep extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column({ type: 'varchar', length: 2 })
    status: Status;

    @Column()
    contactDetails: string;

    @ManyToOne(() => Employee, (employee) => employee.salesReps, { nullable: false })
    user: Employee;

    @ManyToOne(() => SystemUsers, (systemUser) => systemUser.salesReps, { nullable: true })
    systemUser: SystemUsers;

    @OneToMany(() => Order, (order) => order.salesRep)
    orders: Order[];

    @OneToMany(() => Expense, (expense) => expense.salesRep)
    expenses: Expense[];

    @OneToMany(() => Vehicle, (vehicle) => vehicle.salesRep)
    vehicles: Vehicle[];

    @Column()
    createdBy: string;

    @Column({ nullable: true })
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({ nullable: true })
    updatedAt: Date;
}
