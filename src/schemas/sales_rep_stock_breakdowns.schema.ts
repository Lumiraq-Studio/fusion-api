import {BaseEntity, Column, Entity, ManyToOne, OneToMany, PrimaryGeneratedColumn} from 'typeorm';
import {SalesRepStock} from './sales_rep_stock.schema';
import {OrderItem} from "./order-item.schema";
import {VariantStock} from "./variant-stocks.schema";

@Entity('tbl_rep_stock_breakdowns')
export class SalesRepStockBreakdown extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => SalesRepStock, (repStock) => repStock.breakdowns, { nullable: false })
    salesRepStock: SalesRepStock;

    @OneToMany(() => OrderItem, (orderItem) => orderItem.repStock)
    orderItems: OrderItem[];

    @ManyToOne(() => VariantStock, (variantStock) => variantStock.breakdowns, { nullable: false })
    variantStock: VariantStock;

    @Column({ default: 0 })
    assignedQty: number;

    @Column()
    status: string;

    @Column({ default: 0 })
    soldQty: number;

    @Column({ default: 0 })
    remainingQty: number;

}
