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
import {SalesRep} from './sales_rep.schema';
import {SalesRepStockBreakdown} from "./sales_rep_stock_breakdowns.schema";


@Entity('tbl_rep_stock')
export class SalesRepStock extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    assignDate: string;

    @Column()
    status: string;

    @ManyToOne(() => SalesRep, { nullable: false })
    salesRep: SalesRep;

    @OneToMany(() => SalesRepStockBreakdown, (bd) => bd.salesRepStock)
    breakdowns: SalesRepStockBreakdown[];

    @Column()
    createdBy: string;

    @Column({ nullable: true })
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({ nullable: true })
    updatedAt: Date;
}
