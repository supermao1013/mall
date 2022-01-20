<template>
	<view class="container">
		<video class="tui-video" :src="url" enable-danmu danmu-btn controls autoplay enable-play-gesture show-mute-btn
			show-casting-button show-screen-lock-button play-btn-position="bottom">
		</video>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				url: ''
			}
		},
		onLoad(option) {
			this.url = option.url
		},
		methods: {

		}
	}
</script>

<style>
	page,
	.container {
		height: 100%;
		background-color: #000000;
	}

	.container {
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.tui-video {
		width: 100%;
		height: 100%;
	}
</style>
