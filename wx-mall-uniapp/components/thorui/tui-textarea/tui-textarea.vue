<template>
	<view :class="{'tui-textarea__border':textareaBorder}" @tap="fieldClick">
		<view class="tui-textarea__wrap"
			:class="{'tui-line__left':lineLeft,'tui-border__top':!borderTop || textareaBorder,'tui-border__bottom':!borderBottom || textareaBorder,'tui-textarea__flex-start':flexStart}"
			:style="{padding:padding,backgroundColor:backgroundColor,marginTop:marginTop+'rpx'}">
			<view class="tui-textarea__required" :class="{'tui-required__flex-start':flexStart}"
				:style="{color:requiredColor,top:flexStart?requiredTop:'50%'}" v-if="required">*</view>
			<view class="tui-textarea__label" :style="{fontSize:labelSize+'rpx',color:labelColor,minWidth:labelWidth+'rpx'}"
				v-if="label">
				{{label}}
			</view>
			<slot name="left"></slot>
			<view class="tui-textarea__flex-1">
				<textarea class="tui-textarea__self" :class="{'tui-text__right':textRight}"
					:style="{height:height,minHeight:minHeight,fontSize:size+'rpx',color:color}"
					placeholder-class="tui-placeholder" :name="name" :value="value" :placeholder="placeholder"
					:placeholderStyle="placeholderStyl" :disabled="disabled" :maxlength="maxlength" :focus="focused"
					:auto-height="autoHeight" :fixed="fixed" :confirm-type="confirmType"
					:show-confirm-bar="showConfirmBar" :cursor="cursor" :selection-start="selectionStart"
					:selection-end="selectionEnd" :adjust-position="adjustPosition" :hold-keyboard="holdKeyboard"
					:disable-default-padding="disableDefaultPadding" :auto-blur="autoBlur" @focus="onFocus"
					@blur="onBlur" @input="onInput" @confirm="onConfirm" @linechange="onLinechange"
					@keyboardheightchange="onKeyboardheightchange"></textarea>
				<view class="tui-textarea__counter" :style="{fontSize:counterSize+'rpx',color:counterColor}"
					v-if="isCounter && maxlength!=-1">
					{{count}}/{{maxlength}}
				</view>
			</view>
			<slot name="right"></slot>
		</view>
	</view>
</template>

<script>
	export default {
		name: "tui-textarea",
		//这里加group是为了避免在表单中使用时给组件加value属性
		behaviors: ['uni://form-field-group'],
		options: {
			// #ifdef MP-WEIXIN
			addGlobalClass: true,
			// #endif
			virtualHost: true
		},
		props: {
			//是否为必填项
			required: {
				type: Boolean,
				default: false
			},
			requiredColor: {
				type: String,
				default: '#EB0909'
			},
			requiredTop: {
				type: String,
				default: '32rpx'
			},
			//左侧标题
			label: {
				type: String,
				default: ''
			},
			//标题字体大小
			labelSize: {
				type: Number,
				default: 32
			},
			labelColor: {
				type: String,
				default: '#333'
			},
			//label 最小宽度 rpx
			labelWidth: {
				type: Number,
				default: 140
			},
			//获取焦点
			focus: {
				type: Boolean,
				default: false
			},
			autoHeight: {
				type: Boolean,
				default: false
			},
			fixed: {
				type: Boolean,
				default: false
			},
			placeholder: {
				type: String,
				default: ''
			},
			placeholderStyle: {
				type: String,
				default: ''
			},
			//输入框名称
			name: {
				type: String,
				default: ''
			},
			//输入框值
			value: {
				type: String,
				default: ''
			},
			disabled: {
				type: Boolean,
				default: false
			},
			maxlength: {
				type: [Number, String],
				default: 140
			},
			cursorSpacing: {
				type: Number,
				default: 0,
			},
			confirmType: {
				type: String,
				default: 'done'
			},
			showConfirmBar: {
				type: Boolean,
				default: true
			},
			cursor: {
				type: Number,
				default: -1
			},
			selectionStart: {
				type: Number,
				default: -1
			},
			selectionEnd: {
				type: Number,
				default: -1
			},
			adjustPosition: {
				type: Boolean,
				default: true
			},
			disableDefaultPadding: {
				type: Boolean,
				default: true
			},
			holdKeyboard: {
				type: Boolean,
				default: false
			},
			autoBlur: {
				type: Boolean,
				default: false
			},
			height: {
				type: String,
				default: '200rpx'
			},
			minHeight: {
				type: String,
				default: '200rpx'
			},
			//标题与输入框是否顶端对齐
			flexStart: {
				type: Boolean,
				default: false
			},
			//输入框字体大小 rpx
			size: {
				type: Number,
				default: 32
			},
			//输入框字体颜色
			color: {
				type: String,
				default: '#333'
			},
			// 是否显示 textarea 边框
			textareaBorder: {
				type: Boolean,
				default: false
			},
			// 是否显示上边框
			borderTop: {
				type: Boolean,
				default: true
			},
			// 是否显示下边框
			borderBottom: {
				type: Boolean,
				default: true
			},
			//下边框线条是否有左偏移距离
			lineLeft: {
				type: Boolean,
				default: false
			},
			// 是否自动去除两端的空格
			trim: {
				type: Boolean,
				default: true
			},
			textRight: {
				type: Boolean,
				default: false
			},
			//输入框padding值
			padding: {
				type: String,
				default: '26rpx 30rpx'
			},
			//输入框背景颜色
			backgroundColor: {
				type: String,
				default: '#FFFFFF'
			},
			//输入框margin-top值 rpx
			marginTop: {
				type: Number,
				default: 0
			},
			//是否显示底部输入长度计数
			isCounter: {
				type: Boolean,
				default: false
			},
			//计数文本颜色
			counterColor: {
				type: String,
				default: '#999'
			},
			//计数文本大小 rpx
			counterSize: {
				type: Number,
				default: 28
			}
		},
		data() {
			return {
				placeholderStyl: '',
				count: 0,
				focused: false
			};
		},
		watch: {
			focus(val) {
				this.$nextTick(() => {
					this.focused = val
				})
			},
			placeholderStyle(){
				this.fieldPlaceholderStyle()
			}
		},
		created() {
			this.fieldPlaceholderStyle()
		},
		methods: {
			fieldPlaceholderStyle() {
				if (this.placeholderStyle) {
					this.placeholderStyl = this.placeholderStyle
				} else {
					this.placeholderStyl = `fontSize:${this.size}rpx`
				}
			},
			onInput(event) {
				let value = event.detail.value;
				if (this.trim) value = this.trimStr(value);
				this.count = value.length;
				this.$emit('input', value);
			},
			onFocus(event) {
				this.$emit('focus', event);
			},
			onBlur(event) {
				this.$emit('blur', event);
			},
			onConfirm(e) {
				this.$emit('confirm', e.detail.value);
			},
			fieldClick() {
				this.$emit('click', {
					name: this.name
				});
			},
			onLinechange(e) {
				this.$emit('linechange', e.detail)
			},
			onKeyboardheightchange(e) {
				this.$emit('keyboardheightchange', e.detail)
			},
			trimStr(str) {
				return str.replace(/^\s+|\s+$/g, '');
			}
		}
	}
</script>

<style>
	.tui-textarea__wrap {
		width: 100%;
		display: flex;
		align-items: center;
		position: relative;
		box-sizing: border-box;
	}

	.tui-textarea__flex-start {
		align-items: flex-start !important;
	}

	.tui-textarea__wrap::before {
		/* #ifndef APP-NVUE */
		content: ' ';
		/* #endif */
		position: absolute;
		top: 0;
		right: 0;
		left: 0;
		border-top: 1px solid var(--thorui-line-color, rgba(0, 0, 0, 0.1));
		-webkit-transform: scaleY(0.5);
		transform: scaleY(0.5);
		transform-origin: 0 0;
		z-index: 2;
		pointer-events: none;
	}

	.tui-textarea__wrap::after {
		/* #ifndef APP-NVUE */
		content: ' ';
		/* #endif */
		position: absolute;
		border-bottom: 1px solid var(--thorui-line-color, rgba(0, 0, 0, 0.1));
		-webkit-transform: scaleY(0.5);
		transform: scaleY(0.5);
		transform-origin: 0 100%;
		bottom: 0;
		right: 0;
		left: 0;
		z-index: 2;
		pointer-events: none;
	}

	.tui-line__left::after {
		left: 30rpx !important;
	}

	.tui-border__top::before {
		border-top: 0;
	}

	.tui-border__bottom::after {
		border-bottom: 0;
	}

	.tui-textarea__required {
		height: 30rpx;
		position: absolute;
		left: 0;
		left: 12rpx;
		transform: translateY(-50%);
	}

	.tui-required__flex-start {
		transform: translateY(0);
	}

	.tui-textarea__label {
		padding-right: 12rpx;
		flex-shrink: 0;
	}

	.tui-textarea__self {
		width: 100%;
		overflow: visible;
	}

	.tui-placeholder {
		color: var(--thorui-text-color-placeholder, #ccc);
		overflow: visible;
	}

	/* #ifdef MP */
	>>>.tui-placeholder {
		color: var(--thorui-text-color-placeholder, #ccc);
		overflow: visible;
	}

	/* #endif */

	.tui-textarea__border {
		border-radius: 4rpx;
		position: relative;
	}

	.tui-textarea__border::after {
		/* #ifndef APP-NVUE */
		content: ' ';
		/* #endif */
		position: absolute;
		height: 200%;
		width: 200%;
		border: 1px solid var(--thorui-border-color, #d1d1d1);
		transform-origin: 0 0;
		transform: scale(0.5);
		left: 0;
		top: 0;
		border-radius: 8rpx;
		pointer-events: none;
	}

	.tui-textarea__flex-1 {
		flex: 1;
	}

	.tui-textarea__counter {
		padding-top: 8rpx;
		text-align: right;
	}
</style>
