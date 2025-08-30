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
import {Order} from './order.schema';
import {ProductVariant} from "./product-variant.schema";
import {OrderItemStatus} from "../utils/enums/status.enum";
import {ReturnItem} from "./return_item.schema";
import {SalesRepStockBreakdown} from "./sales_rep_stock_breakdowns.schema";

@Entity('tbl_order_item')
export class OrderItem extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => Order, (order) => order.items, { nullable: false })
    order: Order;

    @ManyToOne(() => ProductVariant, { nullable: false })
    variant: ProductVariant;

    @ManyToOne(() => SalesRepStockBreakdown, (breakdown) => breakdown.orderItems, { nullable: true, onDelete: 'CASCADE' })
    repStock: SalesRepStockBreakdown;

    @Column()
    price: number;

    @Column()
    quantity: number;

    @Column()
    totalPrice: number;

    @Column({ type: 'enum', enum: OrderItemStatus, default: OrderItemStatus.ACTIVE })
    status: OrderItemStatus;

    @OneToMany(() => ReturnItem, (returnItem) => returnItem.orderItem)
    returnItems: ReturnItem[];

    @Column()
    createdBy: string;

    @Column({nullable: true})
    updatedBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({nullable: true})
    updatedAt: Date;
}
