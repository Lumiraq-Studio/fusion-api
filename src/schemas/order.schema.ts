import {
    BaseEntity,
    Column,
    Entity,
    ManyToOne,
    OneToMany,
    OneToOne,
    PrimaryGeneratedColumn,
    UpdateDateColumn
} from 'typeorm';
import {Shop} from "./shop.schema";
import {SalesRep} from "./sales_rep.schema";
import {OrderItem} from "./order-item.schema";
import {Return} from "./return.schema";
import {OrderStatus} from "../utils/enums/status.enum";
import {PaymentType} from "./payment_type.schema";


@Entity('tbl_order')
export class Order extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;

    @Column({nullable:false})
    orderReference: string;

    @Column()
    orderDate: string;

    @Column()
    orderType: string;

    @Column()
    uuId: string;

    @Column({type: 'enum', enum: OrderStatus, default: OrderStatus.PAID})
    orderStatus: OrderStatus.PAID;

    @OneToOne(() => Return, (returnRecord) => returnRecord.order, { nullable: true })
    returnRecord: Return;

    @ManyToOne(() => Shop, (shop) => shop.orders)
    shop: Shop;

    @ManyToOne(() => SalesRep, (salesRep) => salesRep.orders)
    salesRep: SalesRep;

    @OneToMany(() => OrderItem, (orderItem) => orderItem.order)
    items: OrderItem[];

    @ManyToOne(() => PaymentType, { nullable: false })
    paymentType: PaymentType;

    @Column({default:0})
    paid: number;

    @Column({nullable:true})
    note: string;

    @Column()
    createdBy: string;

    @Column({nullable: true})
    updatedBy: string;

    @Column({nullable: true})
    createdAt: Date;

    @Column({ nullable: true, type: 'time' })
    createdTime: string;

    @UpdateDateColumn({nullable: true})
    updatedAt: Date;

}
