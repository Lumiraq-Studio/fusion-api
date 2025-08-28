import {
    BaseEntity,
    Column,
    CreateDateColumn,
    Entity,
    ManyToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from "typeorm";
import {Return} from "./return.schema";
import {ProductVariant} from "./product-variant.schema";
import {OrderItem} from "./order-item.schema";


@Entity('tbl_return_item')

export class ReturnItem extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @ManyToOne(() => Return, (returnRecord) => returnRecord.returnItems, { nullable: false })
    returnRecord: Return;

    @ManyToOne(() => ProductVariant, { nullable: false })
    variant: ProductVariant;

    @Column()
    quantityReturned: number;

    @Column({ type: 'text', nullable: true })
    reason: string;

    @Column()
    createdBy: string;

    @CreateDateColumn()
    createdAt: Date;

    @UpdateDateColumn({ nullable: true })
    updatedAt: Date;

    @ManyToOne(() => OrderItem, (orderItem) => orderItem.returnItems, { nullable: false })
    orderItem: OrderItem;
}
