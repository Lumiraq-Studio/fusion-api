import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    ManyToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';
import {SalesRep} from './sales_rep.schema';

@Entity('tbl_expense')
export class Expense extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({
        nullable: true
    })
    expensesType: string;

    @Column()
    expensesDate: string;

    @Column()
    description: string;

    @Column({default: 0})
    amount: number;

    @Column({default: 0})
    expendAmount: number;

    @Column({default: 0})
    incomeAmount: number;

    @ManyToOne(() => SalesRep, (salesRep) => salesRep.expenses, {nullable: true})
    salesRep: SalesRep;

    @Column()
    createdBy: string;

    @Column({nullable: true})
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({nullable: true})
    updatedAt: Date;
}
